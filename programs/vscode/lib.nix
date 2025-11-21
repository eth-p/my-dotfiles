# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  config,
  ...
}:
{

  # mkDarwinOr creates a darwinOr function which returns the first value if
  # the target system is Darwin, or the second value if the target system is
  # not Darwin.
  #
  # mkDarwinOr :: pkgs -> string string -> string
  mkDarwinOr = pkgs: if pkgs.stdenv.isDarwin then mac: _: mac else _: other: other;

  # vscodeCfg refers to the top-level config for my-dotfiles vscode.
  vscodeCfg = config.my-dotfiles.vscode;

  # extensionsDir is the path to VS Code's extensions directory, relative
  # to the user's home directory.
  extensionsDir = ".vscode/extensions";
}
