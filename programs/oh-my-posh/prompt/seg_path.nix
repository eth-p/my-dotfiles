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
    foreground = "p:path_parent";
    background = "p:path_bg";
    template = " {{ if ne .Path \"/\" }}{{ dir .Path }}/{{ end }}";
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
    template = "{{ if eq .Path \"/\" }} {{ end }}<b>{{ .Path }}</b>";
    properties = {
      style = "folder";
    };
  }

  # Annotations added after the path.
  {
    enable = true;
    segments = generator.mkSegments cfg.pathAnnotations;
  }

  # Closing arrow:
  #  
  {
    type = "text";
    style = "diamond";
    leading_diamond = "";
    trailing_diamond = "";
    foreground = "p:path_bg";
    background = "p:path_bg";
    template = "<,p:path_bg> </>";
  }

]
