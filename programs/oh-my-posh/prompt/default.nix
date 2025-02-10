# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  main = (import ./block_main.nix inputs);
  final_newline = (import ./block_final_newline.nix inputs);
}
