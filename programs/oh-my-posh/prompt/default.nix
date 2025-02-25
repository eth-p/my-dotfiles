# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  flags = (import ./flags.nix inputs);
  path = (import ./path.nix inputs);
  time = (import ./time.nix inputs);
  newline_leading = (import ./block_newline_leading.nix inputs);
  newline_trailing = (import ./block_newline_trailing.nix inputs);
}
