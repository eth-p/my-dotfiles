# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://direnv.net/
# ==============================================================================
{ lib, config, pkgs, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.direnv;
in
{
  options.my-dotfiles.direnv = {
    enable = lib.mkEnableOption "install direnv";

    hideDiff = lib.mkEnableOption "hide the environment variable diff";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure direnv.
    {
      programs.direnv = {
        enable = true;
      };
    }

    # Hide the env var diff.
    (mkIf cfg.hideDiff {
      programs.direnv.config = {
        global.hide_env_diff = true;
      };
    })

  ]);
}
