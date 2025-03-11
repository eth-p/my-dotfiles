# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/eza-community/eza
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.eza;
  ezaHome = "${config.xdg.configHome}/eza";
  themes = (import ./themes.nix inputs);
in
{
  options.my-dotfiles.eza = {
    enable = lib.mkEnableOption "install and configure eza as a replacement for ls";

    theme = lib.mkOption {
      type = lib.types.enum themes.all;
      description = "the theme to use";
      default = "base16";
    };

    enableAliases = lib.mkOption {
      type = lib.types.bool;
      description = "Enable shell aliases.";
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure eza.
    {
      programs.eza = {
        enable = true;
        package = pkgs-unstable.eza;
        git = true; # uses libgit2

        enableBashIntegration = cfg.enableAliases;
        enableZshIntegration = cfg.enableAliases;
        enableFishIntegration = cfg.enableAliases;
        enableIonIntegration = cfg.enableAliases;
        enableNushellIntegration = cfg.enableAliases;
      };
    }

    # Set eza's theme file.
    (mkIf (cfg.theme != "default") {
      home.file."${ezaHome}/theme.yml" = {
        source = ./themes + "/${cfg.theme}.yaml";
      };

      # Tell eza to look for config under ~/.config on MacOS.
      home.sessionVariables.EZA_CONFIG_DIR = ezaHome;
    })

  ]);

}
