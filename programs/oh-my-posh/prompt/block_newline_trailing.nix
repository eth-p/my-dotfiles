# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Block (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  enable = cfg.newline;
  priority = 1000;

  type = "prompt";
  alignment = "left";

  force = true;
  segments = [
    {
      type = "text";
      style = "plain";
      template = "\n ∘ ";
    }
  ];
}
