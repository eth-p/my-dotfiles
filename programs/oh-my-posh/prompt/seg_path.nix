# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# Type: Segments (https://ohmyposh.dev/docs/configuration/segment)
# ==============================================================================
{ config, cfg, generator, ... } @ inputs: [

  # Path segment:
  #  ~/P/g/
  {
    type = "path";
    style = "diamond";
    foreground = "p:path_parent";
    background = "p:path_bg";
    template = " {{ if and (ne .Path \"/\") (ne .Path \"~\") }}{{ dir .Path }}/{{ end }}";
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
    template = "{{ if or (eq .Path \"/\") (eq .Path \"~\") }} {{ end }}<b>{{ .Path }}</b>";
    properties = {
      style = "folder";
    };
  }

  # Annotations added after the path.
  {
    enable = true;
    segments = generator.mkSegments cfg.pathAnnotations;
  }

]
