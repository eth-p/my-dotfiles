# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This imports all the program modules.
#
# All of them must be loaded by home-manager as modules.
# Enabling specific configurations should be done by setting
# `my-dotfiles.programs.${program}.enable` to true.
# ==============================================================================
{ ... }:
{
  imports = [
    ./bat
    ./bitwarden
    ./btop
    ./carapace
    ./devenv
    ./direnv
    ./discord
    ./ets
    ./eza
    ./fd
    ./fish
    ./fzf
    ./git
    ./github-cli
    ./github-act
    ./glow
    ./kubectl
    ./kubesel
    ./lf
    ./neovim
    ./oh-my-posh
    ./ranger
    ./ranger/patch-scope-options.nix
    ./ripgrep
    ./uv
    ./vicinae
    ./vscode
    ./yq
    ./zoxide
  ];

}
