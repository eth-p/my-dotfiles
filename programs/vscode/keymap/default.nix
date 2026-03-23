# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Includes each submodule.
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
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.keymap;
in
{
  imports = [
    ./bind-cw.nix
    ./help.nix
    ./style-intellij.nix
  ];

  options.my-dotfiles.vscode.keymap = {
    style = lib.mkOption {
      type = lib.types.enum [
        "default"
        "intellij"
      ];
      description = "use alternate keybindings";
      default = "default";
    };

    bindings = lib.mkOption {
      type = lib.types.listOf vscode.types.keybind;
      description = "custom keybindings";
      default = [ ];
    };
  };

  config = mkIf (vscodeCfg.enable) (mkMerge [
    {
      programs.vscode.profiles.default.keybindings = vscode.generate.vsCodeKeybindings cfg.bindings;
    }
  ]);
}
