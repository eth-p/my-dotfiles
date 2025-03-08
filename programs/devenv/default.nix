# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://devenv.sh/
# ==============================================================================
{ lib, pkgs, pkgs-unstable, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.devenv;
in
{
  options.my-dotfiles.devenv = with lib; {
    enable = mkEnableOption "install devenv";
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure devenv.
    {
      home.packages = [
        pkgs-unstable.devenv
      ];
    }

  ]);
}
