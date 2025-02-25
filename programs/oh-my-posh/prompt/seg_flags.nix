# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Segments (https://ohmyposh.dev/docs/configuration/segment)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: [

  # Exit code segment:
  {
    type = "status";
    style = "diamond";
    trailing_diamond = "";

    foreground = "p:flags_exitcode_color";
    background = "p:flags_bg";

    template = " <b>{{ .String }}</b> ";

    properties = { };
  }

]
