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
  imports = [
    ./extension-klock.nix
    ./my-aliases.nix
    ./my-defaults.nix
    ./shell-aliases.nix
  ];

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

    color = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "use kubecolor for kubectl output";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kubecolor;
        description = "the kubecolor package to install";
      };
    };
  };

  config =
    let
      enabledAliases = kuberc.onlyEnabledAliasesIn cfg.extraAliases;

      emptyKuberc = kuberc.generate {
        aliases = { };
        defaults = { };
      };

      configKuberc = kuberc.generate {
        defaults = cfg.extraDefaults;
        aliases = enabledAliases;
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

      # Install kubecolor.
      (mkIf cfg.color.enable {
        home.packages = [
          cfg.color.package
        ];

        programs.fish.functions.kubectl = {
          wraps = "kubectl";
          body = ''
            kubecolor $argv
          '';
        };
      })

      # Add carapace overlay for custom aliases.
      (mkIf (enabledAliases != { }) {
        my-dotfiles.carapace.overlays.kubectl = {
          name = "kubectl";
          commands = (lib.attrsets.mapAttrsToList kuberc.carapaceOverlayForAlias enabledAliases);
        };
      })

    ]);
}
