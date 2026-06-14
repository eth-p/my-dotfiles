# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.devenv;
in
{
  options.my-dotfiles.vscode.devenv = {
    enable = lib.mkEnableOption "add devenv support";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install Devenv
    # https://marketplace.visualstudio.com/items?itemName=datakurre.devenv
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          datakurre.devenv
        ];
      };
    }

  ]);
}
