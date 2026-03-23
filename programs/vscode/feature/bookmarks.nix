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
  cfg = vscodeCfg.bookmarks;
in
{
  options.my-dotfiles.vscode.bookmarks = {
    enable = lib.mkEnableOption "add bookmark support";
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
      my-dotfiles.vscode.keymap.bindings = [

        # Bookmarks: Toggle
        {
          key = if isDarwin then "cmd+k b" else "ctrl+k b";
          command = "bookmarks.toggle";
          when = "editorTextFocus";
        }

        # Bookmarks: Toggle Labeled
        {
          key = if isDarwin then "cmd+k shift+b" else "ctrl+k shift+b";
          command = "bookmarks.toggleLabeled";
          when = "editorTextFocus";
        }

      ];
    }

  ]);
}
