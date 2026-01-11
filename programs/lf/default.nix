# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/gokcehan/lf
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  lfHome = "${config.xdg.configHome}/lf";
  cfg = config.my-dotfiles.lf;
  themes = (import ./themes.nix inputs);
in
{
  options.my-dotfiles.lf = {
    enable = lib.mkEnableOption "install and configure lf";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure lf.
    {
      programs.lf = {
        enable = true;
      };

      home.file."${lfHome}/colors" = {
        source = ./themes/base16.dircolors;
      };
    }

  ]);
}
