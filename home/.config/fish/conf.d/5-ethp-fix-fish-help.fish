# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Running `help` on SteamOS opens in KWrite by default.
#
#   Changing the default via Dolphin results in text being dumped into the
#   console, which also isn't ideal. This script forces `help` to use a browser
#   and swallows all the messages it outputs.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Fixes fish `help` on SteamOS.
#
# Requirements
# ------------
#
#   * Config: 3-ethp-query-distro.fish
#
# =============================================================================

switch "$ethp_sys_distro"

case "steamos"

	# Find the default browser.
	set -l default_browser (xdg-mime query default 'text/html')
	set -l default_browser_file (
		find \
			"$HOME/.local/share/applications" \
			"/usr/local/share/applications" \
			"/usr/share/applications" \
			-name "$default_browser"
	)

	set -l browser_launch (
		grep '^Exec=' "$default_browser_file" |
		sed '2,$d; s/^Exec=//'
	)

	# Override the help browser.
	set -g fish_help_browser \
		bash -c "$browser_launch \"\$@\" &>/dev/null" '--'
	
end
