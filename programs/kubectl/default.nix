# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://kubernetes.io/docs/reference/kubectl/
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
  cfg = config.my-dotfiles.kubectl;
  cfgGlobal = config.my-dotfiles.global;
in
{
  options.my-dotfiles.kubectl = {
    enable = lib.mkEnableOption "install kubectl";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kubectl;
      description = "the kubectl package to install";
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install kubectl.
    {
      home.packages = [
        cfg.package
      ];
    }

  ]);
}
