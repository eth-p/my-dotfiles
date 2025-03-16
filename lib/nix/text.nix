# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for working with text.
# ==============================================================================
{ lib, ... }:
{
  # nerdglyphOr returns the specified glyph if the first argument is true,
  # or the specified textual replacement otherwise. 
  # 
  # nerdglyphOr :: bool string string -> string
  nerdglyphOr = enabled:
    if enabled
    then nfCodepoint: txtIcon: builtins.fromJSON (''"\u${nfCodepoint}'')
    else nfCodepoint: txtIcon: txtIcon;
}
