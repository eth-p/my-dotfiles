# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/aristocratos/btop
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.btop;
in
{
  options.my-dotfiles.btop = {
    enable = lib.mkEnableOption "install and configure btop";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure btop.
    {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "TTY";
          rounded_corners = false;

          proc_per_core = true; # show cpu usage per core
          vim_keys = true; # navigate with `hjkl`

          cpu_single_graph = true;
        };
      };
    }

  ]);
}
