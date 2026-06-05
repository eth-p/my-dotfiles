# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/eth-p/kubesel
# ==============================================================================
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.kubesel;

in
{
  options.my-dotfiles.kubesel = {
    enableShellAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "add shell aliases and abbreviations for kubesel commands";
    };

    enableFishAliases = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enableShellAliases;
      description = "add fish shell aliases and abbreviations for kubesel commands";
    };
  };

  config = mkIf (cfg.enable && cfg.enableShellAliases) (mkMerge [

    # Fish shell aliases and abbreviations.
    (mkIf cfg.enableFishAliases {
      programs.fish = {
        shellAliases = {
          kk = "kubesel";
        };
      };
    })

  ]);
}
