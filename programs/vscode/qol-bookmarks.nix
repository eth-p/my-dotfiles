# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.qol.bookmarks;
  extensions = pkgs.vscode-extensions;
in
{
  options.my-dotfiles.vscode.qol.bookmarks = {
    enable = lib.mkEnableOption "add bookmarking support";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install Bookmarks
    # https://marketplace.visualstudio.com/items?itemName=alefragnani.bookmarks
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          alefragnani.bookmarks
        ];
      };
    }

  ]);
}
