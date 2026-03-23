# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Library functions specific to Visual Studio Code configuration.
# ==============================================================================
{
  ...
}:
{

  # getConfig returns the config for the my-dotfiles Visual Studio Code module.
  #
  # getConfig :: config -> attrset
  getConfig = config: config.my-dotfiles.vscode;

  # extensionsDir is the path to VS Code's extensions directory, relative
  # to the user's home directory.
  extensionsDir = ".vscode/extensions";
}
