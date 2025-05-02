# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for working with text.
# ==============================================================================
{ lib, ... }:
{
  # nerdOr returns the first string (glyph) if the first argument is true,
  # or the second string (textual replacement) otherwise. 
  # 
  # nerdOr :: bool string string -> string
  nerdOr = enabled:
    if enabled
    then nfIcon: txtIcon: nfIcon
    else nfIcon: txtIcon: txtIcon;
}
