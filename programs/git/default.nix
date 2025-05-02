# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://git-scm.com/
# ==============================================================================
{ lib, config, pkgs, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.git;
  cfgGlobal = config.my-dotfiles.global;
  nerdglyphOr = my-dotfiles.lib.text.nerdglyphOr cfgGlobal.nerdfonts;
in
{
  options.my-dotfiles.git = {
    enable = lib.mkEnableOption "install and configure git";
    inPrompt = lib.mkEnableOption "show git info in the shell prompt";

    github = lib.mkEnableOption "install the gh command-line tool";

    fzf = {
      fixup = lib.mkOption {
        type = lib.types.bool;
        description = "Add `git fixup` command";
        default = false;
      };
    };

    useDelta = lib.mkOption {
      type = lib.types.bool;
      description = "Use delta to show diffs.";
      default = true;
    };

    useDyff = lib.mkOption {
      type = lib.types.bool;
      description = "Use dyff to show diffs between YAML files.";
      default = true;
    };

    ignoreMacFiles = lib.mkOption {
      type = lib.types.bool;
      description = "Ignore system files created by MacOS.";
      default = pkgs.stdenv.isDarwin;
    };
  };

  config = mkIf cfg.enable (mkMerge [

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

          # Aliases to get diffs:
          sdiff = "diff --staged";
          cdiff = ''
            !bash -c "git diff \"''${1:-HEAD}~1\" \"''${1:-HEAD}\""
          '';
        };

        extraConfig = {
          # Show the line(s) of parent commit
          merge.conflictstyle = "zdiff3";

          # Show the changes in `git commit`
          commit.verbose = true;

          # Better diff algorithm, show moved lines differently from changes.
          diff.algorithm = "histogram";
          diff.renames = true;
          diff.colorMoved = true;

          # Sort tags by version.
          tag.sort = "version:refname";

          # Automatically set remote branch if none exists.
          push.autoSetupRemote = true;

          # Update refs in stacked branches when rebasing.
          rebase.updateRefs = true;

          # Prefer rebase over merge when pulling.
          pull.rebase = true;
        };
      };

      # Configure aliases for shells.
      programs.fish.shellAliases = {
        g = "git";
      };
    }

    # Configure gh command.
    (mkIf cfg.github {
      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          aliases = {
            prv = "pr view --web";
          };
        };
      };

      programs.git.aliases = {
        gh = "!gh";
      };
    })

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

    # Install fzf.
    (mkIf cfg.fzf.fixup ({
      home.packages = [
        (pkgs.writeShellApplication {
          name = "git-fzf-fixup";

          runtimeInputs = [ pkgs.git pkgs.fzf ] ++
            (if cfg.useDelta then [ pkgs.delta ] else [ ]);

          text = ''
            useDelta=${toString cfg.useDelta}
            ${builtins.readFile ./git-fzf-fixup.sh}
          '';
        })
      ];
      programs.git.aliases = {
        fixup = "fzf-fixup";
      };
    }))


    # Configure oh-my-posh to show git info.
    (mkIf cfg.inPrompt {
      my-dotfiles.oh-my-posh.pathAnnotations.git = (import ./prompt.nix inputs);
    })
  ]);
}
