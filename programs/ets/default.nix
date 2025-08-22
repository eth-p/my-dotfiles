# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/gdubicki/ets/
# ==============================================================================
{ lib, config, pkgs, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.ets;
in
{
  options.my-dotfiles.ets = {
    enable = lib.mkEnableOption "install and configure ets";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ets
    ];
  };

}
