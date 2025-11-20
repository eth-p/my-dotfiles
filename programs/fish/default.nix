# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/fish-shell/fish-shell
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (import ./generator.nix inputs) mkPrivateFishFunction privateIdent;
  my-pkgs = my-dotfiles.packages."${pkgs.system}";
  cfg = config.my-dotfiles.fish;
  cfgGlobal = config.my-dotfiles.global;
in
{
  options.my-dotfiles.fish = {
    enable = lib.mkEnableOption "install and configure fish";

    isSHELL = lib.mkEnableOption "use as `$SHELL`";
    fixPATH = lib.mkOption {
      type = lib.types.bool;
      description = "fix the PATH variable on login";
      default = pkgs.stdenv.isDarwin;
    };
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
          ${privateIdent "detect_colorscheme"}
        end

        if not functions --query reset
          function reset
            command reset
          end
        end

        functions -c reset ${privateIdent "original_reset"}
        function reset
          ${privateIdent "original_reset"}
          ${privateIdent "detect_colorscheme"}
        end
      '';

      xdg.configFile = builtins.listToAttrs [
        (mkPrivateFishFunction "detect_colorscheme" (import ./functions/detect_colorscheme.nix) {
          inherit my-pkgs;
        })
      ];
    })

    # Use as $SHELL.
    (mkIf cfg.isSHELL {
      home.sessionVariables.SHELL = config.programs.fish.package + "/bin/fish";
    })

    # Fix the PATH variable on login.
    (mkIf cfg.fixPATH {
      programs.fish.loginShellInit = (
        lib.mkOrder 0 ''
          # Fix the PATH
          ${privateIdent "fix_path"}
        ''
      );

      programs.fish.shellInit = (
        lib.mkOrder 0 ''
          # Fix the PATH
          if test -n "$__ETHP_FIXED_PATH" && not status --is-interactive
            ${privateIdent "fix_path"}
          end
        ''
      );

      xdg.configFile = builtins.listToAttrs [
        (mkPrivateFishFunction "fix_path" (import ./functions/fix_path.nix) { })
      ];
    })

  ]);
}
