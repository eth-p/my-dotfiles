# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://git-scm.com/
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
#
# Prompt segment for git status.
# ==============================================================================
{
  lib,
  config,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.git;
  cfgGlobal = config.my-dotfiles.global;
  nerdOr = my-dotfiles.lib.text.nerdOr cfgGlobal.nerdfonts;

  # Icons.
  rebase_icon =
    # E728
    nerdOr "" "rebase";
  commit_icon =
    # F417
    nerdOr " " "@";
  branch_icon =
    # E0A0
    nerdOr "" "";
  tag_icon =
    # F412
    nerdOr " " "tag ";
  onto_icon =
    # 2B9E
    nerdOr "⮞" "onto";

  # Color templates.
  background_templates = [
    # If any unstaged changes.
    ''
      {{- if gt (add .Working.Deleted .Working.Added .Working.Modified .Working.Unmerged) 0 -}}
        p:vcs_modified
      {{- end -}}
    ''

    # If any staged changes.
    ''
      {{- if .Staging.Changed -}}
        p:vcs_staged
      {{- end -}}
    ''

    # Synced.
    "p:vcs_synced"
  ];

  # Segment base config.
  git-segment = {
    type = "git";

    foreground = "p:vcs_fg";
    background = "p:path_bg";
    inherit background_templates;

    style = "diamond";

    templates_logic = "first_match";

    options = {
      fetch_status = true;
      source = "cli";

      inherit
        rebase_icon
        commit_icon
        tag_icon
        branch_icon
        ;
    };
  };

in
{
  # Nested segment to add to the prompt:
  priority = 50;
  segments = [

    # Current git status:
    (
      git-segment
      // {
        leading_diamond = " ";
        templates = [

          # Rebase.
          ''
            {{- if .Rebase }}{{` ` -}}
              ${rebase_icon} [{{ add 1 (sub .Rebase.Total .Rebase.Current) }}] {{``}}
              {{- .Rebase.HEAD }} ${onto_icon} {{``}}
              {{- if eq .Rebase.Onto "undefined" }}(root)
              {{- else }}{{ .Rebase.Onto }}{{- end -}}
            {{` `}}{{ end -}}
          ''

          # Other.
          ''
            {{- ` `}}{{ .HEAD }}{{` ` -}}
          ''

        ];
      }
    )

    # Untracked status:
    (
      git-segment
      // {
        template = "{{- if gt .Working.Untracked 0 -}}*{{` `}}{{- end -}}";
      }
    )

  ];
}
