# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the modules under this directory.
#
# All of them must be loaded by home-manager as modules.
# Enabling specific configurations should be done by setting
# `my-dotfiles.${program}.enable` to true.
# ==============================================================================
[
  ./bat
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
  ./goldwarden
  ./kubesel
  ./neovim
  ./oh-my-posh
  ./ranger
  ./ranger/patch-scope-options.nix
  ./ripgrep
  ./vscode
  ./yq
  ./zoxide
]
