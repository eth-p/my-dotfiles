# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/applejag/kubectl-klock
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
  cfgKubectl = config.my-dotfiles.kubectl;
  cfg = config.my-dotfiles.kubectl.extensions.klock;

  kuberc = (import ./kuberc.nix) { inherit lib; };
  yamlFormat = pkgs.formats.yaml { };

in
{
  imports = [
    ./my-aliases.nix
    ./my-defaults.nix
    ./shell-aliases.nix
  ];

  options.my-dotfiles.kubectl.extensions.klock = {
    enable = lib.mkEnableOption "install kubectl-klock";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kubectl-klock;
      description = "the kubectl-klock package to install";
    };
  };

  config = mkIf (cfg.enable && cfgKubectl.enable) (mkMerge [

    # Install kubectl-klock.
    {
      home.packages = [
        cfg.package
      ];
    }

  ]);
}
