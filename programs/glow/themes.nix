# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Custom themes for glow.
# ==============================================================================
{ lib, config, my-dotfiles, ... }:
let
  inherit (my-dotfiles.lib) theming;
  glowHome = "${config.xdg.configHome}/glow";

  builtinThemes = [
    "auto"
    "dark"
    "light"
    "ascii"
    "notty"
    "dracula"
    "pink"
    "tokyo_night"
  ];

  # Read the available custom themes.
  # These are the JSON files under `./themes` without the file extension.
  customThemes = theming.themeFilesFromDir ".json" ./themes;

  # isCustomTheme returns true if the theme refers to a custom theme in
  # the `./themes` folder.
  isCustomTheme = theme: builtins.elem theme customThemes;

  # toFlag converts the theme to the appropriate value for glow's
  # `--theme` flag (and config option).
  toFlag = theme:
    if (isCustomTheme theme)
    then "${glowHome}/themes/${theme}.json"
    else theme;

in
{
  custom = customThemes;
  all = builtinThemes ++ customThemes;

  inherit isCustomTheme;
  inherit toFlag;
}
