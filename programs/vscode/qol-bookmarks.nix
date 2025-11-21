# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (import ./lib.nix inputs) vscodeCfg mkDarwinOr;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.qol.bookmarks;
  darwinOr = mkDarwinOr pkgs;
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

    # Bookmark Keybindings
    {
      programs.vscode.profiles.default.keybindings = [

        # Bookmarks: Toggle
        {
          "key" = darwinOr "cmd+k b" "ctrl+k b";
          "command" = "bookmarks.toggle";
          "when" = "editorTextFocus";
        }

        # Bookmarks: Toggle Labeled
        {
          "key" = darwinOr "cmd+k shift+b" "ctrl+k shift+b";
          "command" = "bookmarks.toggleLabeled";
          "when" = "editorTextFocus";
        }

      ];
    }

  ]);
}
