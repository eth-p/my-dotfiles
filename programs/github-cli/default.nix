# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://cli.github.com/
# ==============================================================================
{ lib, config, pkgs, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.github-cli;
in
{
  options.my-dotfiles.github-cli = {
    enable = lib.mkEnableOption "install and configure the github CLI tool";
  };

  config = mkIf cfg.enable (mkMerge [

    # Install and configure the `gh` command.
    {
      programs.gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          aliases = {
            prv = "pr view --web";
          };
        };
      };

      # Add it as a git alias, `git gh`.
      programs.git.aliases = {
        gh = "!gh";
      };
    }

  ]);
}
