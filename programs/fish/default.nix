# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/fish-shell/fish-shell
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.fish;
in
{
  options.my-dotfiles.fish = with lib; {
    enable = mkEnableOption "install and configure fish";
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure fish.
    {
      programs.fish = {
        enable = true;
      };
    }

  ]);
}
