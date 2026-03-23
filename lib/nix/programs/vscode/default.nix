# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Library functions specific to Visual Studio Code configuration.
# ==============================================================================
{
  ...
}@inputs:
let
  lib-keybind = (import ./keybind.nix inputs);
in
{
  types = {
    keybind = lib-keybind.type;
  };

  generate = {
    vsCodeKeybinding = lib-keybind.generateVsCodeKeybinding;
    vsCodeKeybindings = lib-keybind.generateVsCodeKeybindings;
  };

  # getConfig returns the config for the my-dotfiles Visual Studio Code module.
  #
  # getConfig :: config -> attrset
  getConfig = config: config.my-dotfiles.vscode;

  # getTerminalPlatformName returns the platform name used for configuring
  # integrated terminal settings.
  #
  # getTerminalPlatformName :: pkgs -> str
  getTerminalPlatformName = pkgs: if pkgs.stdenv.targetPlatform.isDarwin then "osx" else "linux";

  # extensionsDir is the path to VS Code's extensions directory, relative
  # to the user's home directory.
  extensionsDir = ".vscode/extensions";
}
