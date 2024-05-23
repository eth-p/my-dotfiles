function fish_prompt
	if [ "$TERM_PROGRAM" != "WarpTerminal" ]
		promptfessional enable arrow
	end

	promptfessional section hostname
		promptfessional show hostname --only-remote

	promptfessional section status --delimiter=' '
		promptfessional show status
		promptfessional show private
		promptfessional show jobs
		promptfessional show sudo
	
	promptfessional section cmdtime
		promptfessional show cmdtime \
			--min-time=1000 \
			--min-slow=30000

	if [ "$ethp_prompt_kubernetes" = "true" ]
		promptfessional section kubernetes --pattern='%s'
			promptfessional show kubeswitch \
				--pattern='{color} {label}{/context_if_multiple}{/bold_if_namespace}{namespace}³ '
	end
	
	if [ "$ethp_prompt_docker" = "true" ]
		promptfessional section docker --pattern=' %s '
			promptfessional show docker \
				--hide-default \
				--hide-context="default" \
				--symbol=(printf "\u229E")
	end

	if [ "$ethp_prompt_java" = "true" ]
		promptfessional section java --pattern=' %s '
			promptfessional show java \
				--pattern (printf '\u2615{version}')
	end

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

