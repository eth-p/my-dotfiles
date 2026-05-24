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

  kuberc = (import ./kuberc.nix) { inherit lib; };
  yamlFormat = pkgs.formats.yaml { };

in
{
  options.my-dotfiles.kubectl = {
    enable = lib.mkEnableOption "install kubectl";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kubectl;
      description = "the kubectl package to install";
    };

    extraDefaults = lib.mkOption {
      type = lib.types.attrsOf kuberc.types.commandDefaults;
      default = { };
      description = "extra default option overrides for specific kubectl subcommands";
      example = {
        apply = {
          options = {
            server-side = {
              default = "true";
            };
          };
        };
      };
    };

    extraAliases = lib.mkOption {
      type = lib.types.attrsOf kuberc.types.aliasOverride;
      default = { };
      description = "extra kubectl aliases to add to the kuberc file";
      example = {
        gety = {
          command = "get";
          options = {
            output = {
              default = "yaml";
            };
          };
        };
      };
    };
  };

  config =
    let
      emptyKuberc = kuberc.generate {
        aliases = { };
        defaults = { };
      };

      configKuberc = kuberc.generate {
        aliases = cfg.extraAliases;
        defaults = cfg.extraDefaults;
      };
    in
    mkIf cfg.enable (mkMerge [

      # Install and kubectl.
      {
        home.packages = [
          cfg.package
        ];
      }

      # Configure kubectl.
      (mkIf (configKuberc != emptyKuberc) {
        home.file.".kube/kuberc".source = yamlFormat.generate "kubectl-kuberc" configKuberc;
      })

      # Add carapace overlay for custom aliases.
      (mkIf (cfg.extraAliases != { }) {
        my-dotfiles.carapace.overlays.kubectl = {
          name = "kubectl";
          commands = (lib.attrsets.mapAttrsToList kuberc.carapaceOverlayForAlias cfg.extraAliases);
        };
      })

    ]);
}
