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
  cfg = vscodeCfg.keybindings;
  darwinOr = mkDarwinOr pkgs;
in
{
  config = mkIf (cfg."map-cg") (mkMerge [

    # Custom bindings
    {

      programs.vscode.profiles.default.keybindings = [

        # Bind "User View Container: Focus on Outline View" to "ctrl-g o".
        {
          "key" = "ctrl+g o";
          "command" = "outline.focus";
          "when" = "!terminalFocus";
        }

        # Bind "Source Control: Focus on Changes View" to "ctrl-g g".
        {
          "key" = "ctrl+g g";
          "command" = "workbench.scm.focus";
          "when" = "!terminalFocus";
        }

        # Bind "View: Focus Active Editor Group" to "ctrl-g e".
        {
          "key" = "ctrl+g e";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "!terminalFocus";
        }

        # Bind "Problems: Focus on Problems View" to "ctrl-g p".
        {
          "key" = "ctrl+g p";
          "command" = "workbench.panel.markers.view.focus";
          "when" = "!terminalFocus";
        }

        # Bind "Terminal: Focus on Terminal View" to "ctrl-g t".
        {
          "key" = "ctrl+g t";
          "command" = "terminal.focus";
          "when" = "!terminalFocus";
        }

        # Bind "View: Focus Active Editor Group" to "ctrl-k backspace".
        # This is an escape hatch to get out of the terminal.
        {
          "key" = "ctrl+k backspace";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "terminalFocus";
        }

      ];
    }

    # Unbind defaults: Other (not MacOS)-specific
    (mkIf (!pkgs.stdenv.isDarwin) {
      programs.vscode.profiles.default.keybindings = [

        # "Go to Line/Column..."
        {
          "key" = "ctrl+g";
          "command" = "-workbench.action.gotoLine";
        }

      ];
    })

  ]);
}
