# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers that need access to the home-manager `config` variable.
# ==============================================================================
{ config, ... }:
{
  # nerdglyphOr returns the specified glyph if nerdfonts are enabled,
  # or the specified textual replacement otherwise. 
  # 
  # nerdglyphOr :: string string -> string
  nerdglyphOr =
    if config.my-dotfiles.nerdfonts
    then nfCodepoint: txtIcon: builtins.fromJSON (''"\u${nfCodepoint}'')
    else nfCodepoint: txtIcon: txtIcon;
}
