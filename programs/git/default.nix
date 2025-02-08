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

  ]);
}
