# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/mikefarah/yq
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.yq;
in
{
  options.my-dotfiles.yq = {
    enable = lib.mkEnableOption "install and configure yq";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure yq.
    {
      home.packages = [ pkgs.yq-go ];
    }

  ]);
}
