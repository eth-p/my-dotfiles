# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Custom styles for glow.
# ==============================================================================
{ lib, config, ... }:
let
  inherit (lib) mkIf strings attrsets;
  glowHome = "${config.xdg.configHome}/glow";

  builtinStyles = [
    "auto"
    "dark"
    "light"
    "ascii"
    "notty"
    "dracula"
    "pink"
    "tokyo_night"
  ];

  # Read the available custom styles.
  # These are the JSON files under `./styles` without the file extension.
  customStyles = builtins.map
    (strings.removeSuffix ".json")
    (builtins.attrNames (attrsets.filterAttrs
      (name: kind: kind == "regular" && (strings.hasSuffix ".json" name))
      (builtins.readDir ./styles)
    ));

  # isCustomStyle returns true if the style refers to a custom style in
  # the `./styles` folder.
  isCustomStyle = style: builtins.elem style customStyles;

  # toFlag converts the style to the appropriate value for glow's
  # `--style` flag (and config option).
  toFlag = style:
    if (isCustomStyle style)
    then "${glowHome}/styles/${style}.json"
    else style;

in
{
  custom = customStyles;
  all = builtinStyles ++ customStyles;

  inherit isCustomStyle;
  inherit toFlag;
}
