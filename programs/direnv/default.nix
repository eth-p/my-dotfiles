# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://direnv.net/
# ==============================================================================
{ lib, pkgs, pkgs-unstable, config, ctx, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf;
  inherit (my-dotfiles.lib.withConfig inputs) nerdglyphOr;
  cfg = config.my-dotfiles.direnv;
in
{
  options.my-dotfiles.direnv = with lib; {
    enable = mkEnableOption "install direnv";

    hideDiff = mkEnableOption "hide the environment variable diff";
  };

  config = mkIf cfg.enable (lib.mkMerge [

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
