# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script sets up a theme using the my_theme function.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   The theme chosen will depend on the terminal's background color,
#   which is determined in the `~/.config/fish/conf.d/3-ethp-query-term.fish`
#   init script.
#
# =============================================================================

my_theme --style="$TERM_BG"

