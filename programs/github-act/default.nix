# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/nektos/act
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.github-act;
  cfgGlobal = config.my-dotfiles.global;
in
{
  options.my-dotfiles.github-act = {
    enable = lib.mkEnableOption "install and configure act, the local GitHub Actions runner";

    package = lib.mkOption {
      type = lib.types.package;
      description = "the act package to install";
      default = pkgs-unstable.act;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install the `act` command for running GitHub Actions locally.
    {
      home.packages = [
        cfg.package
      ];

      # Add it as a `gh` alias, `gh act`.
      programs.gh.settings.aliases = {
        act = "!act";
      };
    }

  ]);
}
