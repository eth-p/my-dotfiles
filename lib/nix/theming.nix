# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for working with custom themes.
# ==============================================================================
{ lib, ... }:
let
  inherit (lib) strings attrsets;

  # themeFilesFromDir read the theme files under the specified directory
  # and returns their basenames.
  # 
  # themeFilesFromDir :: string path -> [string]
  themeFilesFromDir = ext: dir:
    builtins.map
      (strings.removeSuffix ext)
      (builtins.attrNames (attrsets.filterAttrs
        (name: kind: kind == "regular" && (strings.hasSuffix ext name))
        (builtins.readDir dir)
      ));

in
{
  inherit themeFilesFromDir;
}
