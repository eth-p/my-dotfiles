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
  cfg = vscodeCfg.keybindings;
  darwinOr = mkDarwinOr pkgs;
in
{
  config = mkIf (cfg."map-cw") (mkMerge [

    # Custom bindings
    {

      programs.vscode.profiles.default.keybindings = [

        # Toggle focus to the primary side bar with "ctrl+w tab".
        {
          "key" = "ctrl+w tab";
          "command" = "workbench.action.focusSideBar";
          "when" = "!terminalFocus && !sideBarFocus";
        }

        {
          "key" = "ctrl+w tab";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "!terminalFocus && sideBarFocus";
        }

        # Bind "View: Focus into Secondary Side Bar" to "ctrl+w shift+tab".
        {
          "key" = "ctrl+w shift+tab";
          "command" = "workbench.action.focusAuxiliaryBar";
          "when" = "!terminalFocus";
        }

        # Close editor.
        {
          "key" = "ctrl+w c";
          "command" = "workbench.action.closeActiveEditor";
          "when" = "editorFocus";
        }

        # Select editor from list.
        {
          "key" = "ctrl+w a";
          "command" = "workbench.action.showAllEditorsByMostRecentlyUsed";
          "when" = "!terminalFocus";
        }

      ]

      # Navigate focus with "ctrl+w <arrow key>".
      ++ (lib.lists.flatten (
        (map
          (key: [
            {
              "key" = "ctrl+w ${key}";
              "command" = "workbench.action.focusLeftGroup";
              "when" = "editorFocus";
            }
          ])
          [
            "left"
            "h"
          ]
        )
        ++ (map
          (key: [
            {
              "key" = "ctrl+w ${key}";
              "command" = "workbench.action.focusRightGroup";
              "when" = "editorFocus";
            }
          ])
          [
            "right"
            "l"
          ]
        )
        ++ (map
          (key: [
            {
              "key" = "ctrl+w ${key}";
              "command" = "workbench.action.focusRightGroup";
              "when" = "editorFocus";
            }
          ])
          [
            "up"
            "k"
          ]
        )
        ++ (
          map
            (key: [
              {
                "key" = "ctrl+w ${key}";
                "command" = "workbench.action.focusBelowGroup";
                "when" = "editorFocus";
              }
            ])
            [
              "down"
              "j"
            ]
        )
      ));

    }

    # Unbind defaults: Other (not MacOS)-specific
    (mkIf (!pkgs.stdenv.isDarwin) {
      programs.vscode.profiles.default.keybindings = [

        # "View: Close Editor"
        {
          "key" = "ctrl+w";
          "command" = "-workbench.action.closeActiveEditor";
        }

        # "Terminal: Kill the Active Terminal in Editor Area"
        {
          "key" = "ctrl+w";
          "command" = "-workbench.action.terminal.killEditor";
          "when" =
            "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
        }

        # workbench.action.closeGroup
        {
          "key" = "ctrl+w";
          "command" = "-workbench.action.closeGroup";
          "when" = "activeEditorGroupEmpty && multipleEditorGroups";
        }

      ];
    })

  ]);
}
