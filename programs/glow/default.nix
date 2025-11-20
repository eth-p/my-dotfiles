# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/charmbracelet/glow
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.glow;
  glowHome = "${config.xdg.configHome}/glow";
  themes = (import ./themes.nix inputs);
in
{
  options.my-dotfiles.glow = {
    enable = lib.mkEnableOption "install glow";

    theme = lib.mkOption {
      type = lib.types.enum (themes.all);
      description = "the theme to use";
      default = "base16";
    };
  };

  config = mkIf cfg.enable {

    # Install glow.
    home.packages = [
      pkgs.glow
    ];

    # Configure glow.
    home.file = {
      "${glowHome}/glow.yml" = {
        text = ''
          style: ${builtins.toJSON (themes.toFlag cfg.theme)}
          mouse: true
          pager: true
        '';
      };
    }

    # Add the custom theme files.
    // (builtins.listToAttrs (
      builtins.map (theme: {
        name = "${glowHome}/themes/${theme}.json";
        value = {
          source = ./themes + "/${theme}.json";
        };
      }) themes.custom
    ));

  };
}
