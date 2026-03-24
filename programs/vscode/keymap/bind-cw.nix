# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  config,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.keymap;
in
{
  options.my-dotfiles.vscode.keymap = {
    bind-cw = lib.mkEnableOption "Map Ctrl-W to control panes and focus";
  };

  config = mkIf (cfg.bind-cw) (mkMerge [
    {
      my-dotfiles.vscode.keymap.bindings = [

        # Toggle focus to the primary side bar with "ctrl+w tab".
        {
          name = "Focus Sidebar";
          key = "ctrl+w tab";
          command = "workbench.action.focusSideBar";
          when = "!terminalFocus && !sideBarFocus";
        }

        {
          name = "Focus Editor";
          key = "ctrl+w tab";
          command = "workbench.action.focusActiveEditorGroup";
          when = "!terminalFocus && sideBarFocus";
        }

        # Bind "View: Focus into Secondary Side Bar" to "ctrl+w shift+tab".
        {
          name = "Focus Right Sidebar";
          key = "ctrl+w shift+tab";
          command = "workbench.action.focusAuxiliaryBar";
          when = "!terminalFocus";
        }

        # Close editor.
        {
          name = "Close Active Editor";
          key = "ctrl+w c";
          command = "workbench.action.closeActiveEditor";
          when = "editorFocus";
        }

        # Select editor from list.
        {
          name = "Change Editor...";
          key = "ctrl+w a";
          command = "workbench.action.showAllEditorsByMostRecentlyUsed";
          when = "!terminalFocus";
        }

        # Bind "User View Container: Focus on Outline View" to "ctrl-w g o".
        {
          name = "Focus Outline Panel";
          key = "ctrl+w g o";
          command = "outline.focus";
          when = "!terminalFocus";
        }

        # Bind "Source Control: Focus on Changes View" to "ctrl-w g g".
        {
          name = "Focus Changes Panel";
          key = "ctrl+w g g";
          command = "workbench.scm.focus";
          when = "!terminalFocus";
        }

        # Bind "View: Focus Active Editor Group" to "ctrl-w g e".
        {
          name = "Focus Activate Editor Group";
          key = "ctrl+w g e";
          command = "workbench.action.focusActiveEditorGroup";
          when = "!terminalFocus";
        }

        # Bind "Problems: Focus on Problems View" to "ctrl-w g p".
        {
          name = "Focus Problems Panel";
          key = "ctrl+w g p";
          command = "workbench.panel.markers.view.focus";
          when = "!terminalFocus";
        }

        # Bind "Terminal: Focus on Terminal View" to "ctrl-w g t".
        {
          name = "Focus Terminal";
          key = "ctrl+w g t";
          command = "terminal.focus";
          when = "!terminalFocus";
        }

      ]

      # Navigate focus with "ctrl+w <arrow key>".
      ++ (lib.lists.flatten (
        (map
          (key: [
            {
              name = "Focus Editor Left";
              key = "ctrl+w ${key}";
              command = "workbench.action.focusLeftGroup";
              when = "editorFocus";
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
              name = "Focus Editor Right";
              key = "ctrl+w ${key}";
              command = "workbench.action.focusRightGroup";
              when = "editorFocus";
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
              name = "Focus Editor Above";
              key = "ctrl+w ${key}";
              command = "workbench.action.focusAboveGroup";
              when = "editorFocus";
            }
          ])
          [
            "up"
            "k"
          ]
        )
        ++ (map
          (key: [
            {
              name = "Focus Editor Below";
              key = "ctrl+w ${key}";
              command = "workbench.action.focusBelowGroup";
              when = "editorFocus";
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
    # Unbinding should be done against the config directly.
    (mkIf (!isDarwin) {
      programs.vscode.profiles.default.keybindings = [

        # "View: Close Editor"
        {
          key = "ctrl+w";
          command = "-workbench.action.closeActiveEditor";
        }

        # "Terminal: Kill the Active Terminal in Editor Area"
        {
          key = "ctrl+w";
          command = "-workbench.action.terminal.killEditor";
          when = "terminalEditorFocus && terminalFocus && terminalHasBeenCreated || terminalEditorFocus && terminalFocus && terminalProcessSupported";
        }

        # workbench.action.closeGroup
        {
          key = "ctrl+w";
          command = "-workbench.action.closeGroup";
          when = "activeEditorGroupEmpty && multipleEditorGroups";
        }

      ];
    })

  ]);
}
