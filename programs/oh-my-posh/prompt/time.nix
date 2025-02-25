# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: {
  enable = true;
  priority = 7;

  type = "prompt";
  alignment = "left";
  leading_diamond = "█";
  trailing_diamond = "█";

  segments = [
    # Time segment:
    {
      type = "executiontime";
      style = "diamond";

      foreground = "p:time_color";
      background = "p:time_bg";

      template = "{{ .FormattedMs }}";

      properties = {
        threshold = 500;
        style = "austin";
      };
    }
  ];
}
