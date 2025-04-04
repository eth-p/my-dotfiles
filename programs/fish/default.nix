# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/fish-shell/fish-shell
# ==============================================================================
{ lib, config, pkgs, my-dotfiles, ... }:
let
  inherit (lib) mkIf mkMerge;
  my-pkgs = my-dotfiles.packages."${pkgs.system}";
  cfg = config.my-dotfiles.fish;
  cfgGlobal = config.my-dotfiles.global;
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

    # Detect color scheme.
    (mkIf (cfgGlobal.colorscheme == "auto") {
      programs.fish.shellInit = ''
        # Use terminal background color to set preferred colorscheme.
        if test -z "$PREFERRED_COLORSCHEME"
          __mydotfiles_detect_colorscheme
        end

        if not functions --query reset
          function reset
            command reset
          end
        end
        
        functions -c reset __mydotfiles_original_reset
        function reset
          __mydotfiles_original_reset
          __mydotfiles_detect_colorscheme
        end
      '';

      programs.fish.functions."__mydotfiles_detect_colorscheme" = {
        body = ''
          set -x PREFERRED_COLORSCHEME (${my-pkgs.term-query-bg}/bin/term-query-bg)
        '';
      };
    })

    # Use as $SHELL.
    (mkIf cfg.isSHELL {
      home.sessionVariables.SHELL = config.programs.fish.package + "/bin/fish";
    })

  ]);
}
