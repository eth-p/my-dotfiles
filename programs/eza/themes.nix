# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Custom themes for eza.
# ==============================================================================
{ my-dotfiles, ... }:
let
  inherit (my-dotfiles.lib) theming;

  builtinThemes = [
    "default"
  ];

  # Read the available custom themes.
  # These are the YAML files under `./themes` without the file extension.
  customThemes = theming.themeFilesFromDir ".yaml" ./themes;

  # isCustomTheme returns true if the theme refers to a custom theme in
  # the `./themes` folder.
  isCustomTheme = theme: builtins.elem theme customThemes;

in
{
  custom = customThemes;
  all = builtinThemes ++ customThemes;

  inherit isCustomTheme;
}
