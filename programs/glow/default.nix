# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/charmbracelet/glow
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.my-dotfiles.glow;
in
{
  options.my-dotfiles.glow = with lib; {
    enable = mkEnableOption "install glow";
  };

  config = mkIf cfg.enable {

    # Install glow.
    home.packages = [
      pkgs.glow
    ];

  };
}
