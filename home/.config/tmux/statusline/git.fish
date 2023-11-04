#!/usr/bin/env fish
set RS (printf "\x1E")
set tmux_vars (string split "$RS" (tmux display-message -t "$TMUX_PANE" -p (printf "%s$RS" \
	'#{pane_current_path}' \
	'#{ETHP_SCRIPT}/term-ansi-to-tmux' \
)))

set pane_cwd $tmux_vars[1]
set tmux_fmt $tmux_vars[2]
promptfessional_decoration_git "$pane_cwd" | "$tmux_fmt"