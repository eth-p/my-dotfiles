# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  enable = true;
  priority = 10;

  type = "prompt";
  alignment = "left";

  segments = [
    {
      priority = 10;
      segments = (import ./seg_flags.nix inputs);
    }
    {
      priority = 20;
      segments = (import ./seg_path.nix inputs);
    }
  ];
}
