# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://git-scm.com/
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.my-dotfiles.git;
in
{
  options.my-dotfiles.git = with lib; {
    enable = mkEnableOption "install and configure git";
    inPrompt = mkEnableOption "show git info in the shell prompt";

    useDelta = mkOption {
      type = types.bool;
      description = "Use delta to show diffs.";
      default = true;
    };

    useDyff = mkOption {
      type = types.bool;
      description = "Use dyff to show diffs between YAML files.";
      default = true;
    };

    ignoreMacFiles = mkOption {
      type = types.bool;
      description = "Ignore system files created by MacOS.";
      default = ctx.isDarwin;
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure git.
    {
      programs.git = {
        enable = true;
        lfs.enable = true;

        aliases = {
          ss = "status --short";
          lg = "log --oneline --graph";
          r = "rebase --interactive --autosquash";
          rc = "rebase --continue";
        };
      };

      # Configure aliases for shells.
      programs.fish.shellAliases = {
        g = "git";
      };
    }

    # Configure ignore rules for Mac.
    (mkIf cfg.ignoreMacFiles {
      programs.git.ignores = [
        ".DS_Store"
        "._*"
      ];
    })

    # Configure 'delta' diff tool.
    (mkIf cfg.useDelta {
      programs.git.delta = {
        enable = true;
        options = {
          navigate = true;
        };
      };
    })

    # Configure 'dyff' diff tool.
    (mkIf cfg.useDyff (
      let
        diff_with_dyff = (
          pkgs.writeShellScript "diff_with_dyff" (builtins.readFile ./diff_with_dyff.sh)
        );
      in
      {
        home.packages = [ pkgs.dyff ];
        programs.git = {
          attributes = [
            "*.yml diff=dyff"
            "*.yaml diff=dyff"
          ];

          extraConfig = {
            diff.dyff.command = diff_with_dyff.outPath;
          };
        };
      }
    ))

    # Configure oh-my-posh to show git info.
    (mkIf cfg.inPrompt {
      my-dotfiles.oh-my-posh.pathAnnotations.git = {
        priority = 50;
        type = "git";

        background = "p:vcs_unknown";

        style = "diamond";
        leading_diamond = " ";
        trailing_diamond = "";

        template = (builtins.concatStringsSep "" [
          # Set the colors based on staged/unstaged/synced.
          "{{ $unstaged := (add .Working.Deleted .Working.Added .Working.Modified .Working.Unmerged) }}"
          "{{ if (gt $unstaged 0) }}<p:vcs_fg,p:vcs_modified>"
          "{{ else }}{{ if .Staging.Changed }}<p:vcs_fg,p:vcs_staged>"
          "{{ else }}<p:vcs_fg,p:vcs_synced>"
          "{{ end }}{{ end }} "

          # Show the rebase info.
          # TODO: Need v24.19.0 or later

          # Otherwise, show the current HEAD.
          "{{ .HEAD }}"

          # Show a marker there are untracked files.
          "{{ if gt .Working.Untracked 0 }} *{{ end }}"
          " </>"
        ]);

        properties = {
          fetch_status = true;
          source = "cli";
        } // (
          let
            nerdOr = nfCodepoint: txtIcon:
              if config.my-dotfiles.nerdfonts
              then builtins.fromJSON (''"\u${nfCodepoint}'')
              else txtIcon;
          in
          {
            rebase_icon = nerdOr "E728" "rebase ";
            commit_icon = nerdOr "F417" "@";
          }
        );
      };
    })
  ]);
}
