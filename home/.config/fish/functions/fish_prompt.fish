function fish_prompt
	promptfessional enable arrow

    promptfessional section status --delimiter=' '
        promptfessional show status
        promptfessional show private
        promptfessional show jobs
        promptfessional show sudo

    promptfessional section path --pattern=' %s '
        promptfessional show path \
        	--collapse-home \
        	--abbrev-parents \
        	--decoration promptfessional_decoration_git \
        	--git-hide-branch master \
			--git-symbol-branch (printf "\uE0A0") \
			--git-use-cache

    promptfessional end

	set_color (string replace -- "--background=" "" (promptfessional color section.path --or=component.path --only-background --print))
    promptfessional literal "{arrow}\x1B[0m "
end
