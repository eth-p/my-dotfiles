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
  priority = 10;

  type = "prompt";
  alignment = "left";
  leading_diamond = "█";
  trailing_diamond = "█";

  segments = [
    # Path segment:
    #  ~/P/g/
    {
      type = "path";
      style = "diamond";
      foreground = "p:path_parent";
      background = "p:path_bg";
      template = "{{ if and (ne .Path \"/\") (ne .Path \"~\") }}{{ dir .Path }}/{{ end }}";
      properties = {
        style = "letter";
      };
    }

    # Current working directory segment:
    #  my_dir
    {
      type = "path";
      style = "diamond";
      foreground = "p:path_curdir";
      background = "p:path_bg";
      template = "<b>{{ .Path }}</b>";
      properties = {
        style = "folder";
      };
    }

    # Annotations added after the path.
    {
      enable = true;
      segments = generator.mkSegments cfg.pathAnnotations;
    }

    # An empty template to coerce the trailing diamond color.
    {
      type = "text";
      style = "diamond";
      foreground = "p:path_curdir";
      background = "p:path_bg";
      template = "<><>";
    }
  ];
}
