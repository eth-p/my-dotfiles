# my-dotfiles | Copyright (C) 2026 eth-p
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
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.keymap.help;
in
{
  options.my-dotfiles.vscode.keymap.help = {
    enable = lib.mkEnableOption "show a help menu for multi-key key bindings";
  };

  config = mkIf (cfg.enable) (mkMerge [

    # Install Which Key Extension
    # https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey
    {
      programs.vscode.profiles.default = {
        extensions = with extensions; [ vspacecode.whichkey ];

        userSettings = {
          "whichkey.bindings" = (vscode.generate.whichKeyBindings vscodeCfg.keymap.bindings);
        };

        keybindings = [
          # FIXME: These don't seem to work.
          {
            key = "tab";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "↹";
          }
          {
            key = "shift+tab";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "S-↹";
          }
          {
            key = "up";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "⭡";
          }
          {
            key = "down";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "⭣";
          }
          {
            key = "left";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "⭠";
          }
          {
            key = "right";
            when = "whichKeyVisible";
            command = "whichkey.triggerKey";
            args = "⭢";
          }
        ];
      };
    }

    # Configure menu activations for which-key.
    {
      programs.vscode.profiles.default.keybindings =
        let
          getBindingLeader = kb: vscode.keybind.getChordLeader kb.key;

          allLeadersDupesMaybeNull = map getBindingLeader vscodeCfg.keymap.bindings;
          allLeadersMaybeNull = lib.lists.unique allLeadersDupesMaybeNull;
          allLeaders = lib.lists.filter (leader: leader != null) allLeadersMaybeNull;
        in
        map (leader: {
          key = leader;
          command = "runCommands";
          when = "!terminalFocus";
          args = {
            commands = [
              "whichkey.show"
              {
                command = "whichkey.triggerKey";
                args = leader;
              }
            ];
          };
        }) allLeaders;

    }

  ]);
}
