# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Blocks (https://ohmyposh.dev/docs/configuration/block)
# ==============================================================================
{
  config,
  cfg,
  generator,
  ...
}@inputs:
{
  enable = true;
  priority = 5;

  type = "prompt";
  alignment = "left";
  leading_diamond = "█";
  trailing_diamond = "█";

  segments = [
    # Sudo segment:
    {
      type = "root";
      style = "diamond";
      trailing_diamond = "█";

      foreground = "p:flags_sudo_color";
      background = "p:flags_bg";

      template = "<b>!</b>";

      options = { };
    }

    # Exit code segment:
    {
      type = "status";
      style = "diamond";
      trailing_diamond = "█";

      foreground = "p:flags_exitcode_color";
      background = "p:flags_bg";

      template = "<b>{{ .String }}</b>";

      options = { };
    }
  ];
}
