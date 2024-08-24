# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script enables shell integrations for supported terminal
#   emulators.
#
# =============================================================================

if not status is-interactive
	return
end

# Kitty Terminal
# https://sw.kovidgoyal.net/kitty/
if test -n "$KITTY_PID"
    set --global KITTY_SHELL_INTEGRATION enabled
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end
