# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.vscode;
in
{
  options.my-dotfiles.vscode = {
    enable = lib.mkEnableOption "install and configure Visual Studio Code";
  };

  config = mkIf cfg.enable (mkMerge [

    # Install Visual Studio Code.
    {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
        };
      };

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "vscode" ];
    }

  ]);
}
