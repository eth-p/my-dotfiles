# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Includes each feature submodule.
# ==============================================================================
{
  ...
}:
{
  imports = [
    ./copilot.nix
    ./bookmarks.nix
    ./git.nix
    ./github.nix
    ./kubernetes.nix
    ./todos.nix
    ./devcontainers.nix
    ./ssh.nix
  ];
}
