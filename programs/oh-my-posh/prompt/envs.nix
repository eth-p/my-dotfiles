# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  enable = true;
  priority = 2;

  type = "prompt";
  alignment = "left";
  leading_diamond = "█";
  trailing_diamond = "█";

  segments = generator.mkSegments cfg.envAnnotations;
}
