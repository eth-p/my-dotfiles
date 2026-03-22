# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Includes each submodule.
# ==============================================================================
{
  lib,
  ...
}:
{
  imports = [
    ./bind-cw.nix
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
  };
}
