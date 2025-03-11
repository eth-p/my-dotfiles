# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/fish-shell/fish-shell
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.fish;
in
{
  options.my-dotfiles.fish = {
    enable = lib.mkEnableOption "install and configure fish";

    isSHELL = lib.mkEnableOption "use as `$SHELL`";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure fish.
    {
      programs.fish = {
        enable = true;
      };
    }

    # Prevent `profile.d/nix-daemon.{fish,sh}` from being sourced in nested
    # shells.
    {
      programs.fish = {
        shellInit = ''
          # Prevent nix from prepending to the PATH multiple times.
          set -x __ETC_PROFILE_NIX_SOURCED
          if test -n "$NIX_PROFILES"
            set __ETC_PROFILE_NIX_SOURCED 1
          end
        '';
      };
    }

    # Use as $SHELL.
    (mkIf cfg.isSHELL {
      home.sessionVariables.SHELL = config.programs.fish.package + "/bin/fish";
    })

  ]);
}
