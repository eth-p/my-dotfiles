# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.qol.github;
  extensions = pkgs-unstable.vscode-extensions;
in
{
  options.my-dotfiles.vscode.qol.github = {
    enable =
      lib.mkEnableOption "add GitHub-centric extensions";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install GitHub Actions
    # https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions
    {
      programs.vscode = {
        profiles.default.extensions = with extensions;
          [
            github.vscode-github-actions
          ];
      };
    }

  ]);
}
