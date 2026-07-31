# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://kubernetes.io/docs/reference/kubectl/
# ==============================================================================
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfgKubectl = config.my-dotfiles.kubectl;
  cfg = config.my-dotfiles.kubectl.shellAliases;

in
{
  imports = [
    ./my-aliases.nix
    ./my-defaults.nix
  ];

  options.my-dotfiles.kubectl.shellAliases = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "add shell aliases and abbreviations for kubectl commands";
    };

    alias.k = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable the k alias";
      };
      to = lib.mkOption {
        visible = false;
        type = lib.types.str;
        default = "kubectl";
        description = "the command to alias for the k alias";
      };
    };

    alias.kg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable the kg alias";
      };
      to = lib.mkOption {
        visible = false;
        type = lib.types.str;
        default = "kubectl get";
        description = "the command to alias for the kg alias";
      };
    };

    alias.kd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable the kd alias";
      };
      to = lib.mkOption {
        visible = false;
        type = lib.types.str;
        default = "kubectl describe";
        description = "the command to alias for the kd alias";
      };
    };

    alias.kgo = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable the kgo alias";
      };
      to = lib.mkOption {
        visible = false;
        type = lib.types.str;
        default = "kubectl get -oyaml";
        description = "the command to alias for the kgo alias";
      };
    };

    alias.klog = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enable the klog alias";
      };
      to = lib.mkOption {
        visible = false;
        type = lib.types.str;
        default = "kubectl logs";
        description = "the command to alias for the klog alias";
      };
    };
  };

  config =
    let
      enabledAliases = lib.attrsets.filterAttrs (name: aliasCfg: aliasCfg.enable) cfg.alias;

    in
    mkIf (cfgKubectl.enable && cfg.enable) (mkMerge [

      # Fish shell aliases and abbreviations.
      {
        programs.fish = {
          shellAliases = lib.attrsets.mapAttrs (alias: aliasCfg: aliasCfg.to) enabledAliases;
          shellAbbrs = {
            "--failed" = {
              command = "kg";
              expansion = "--field-selector=status.successful=0";
            };
          };
        };
      }

      (mkIf (cfg.alias.kgo.enable) {
        programs.fish.functions = {
          kgo = {
            wraps = "kubectl get";
            body = ''
              if command -q yq
                ${cfg.alias.kgo.to} $argv | yq .
              else
                ${cfg.alias.kgo.to} $argv
              end
            '';
          };
        };
      })

    ]);
}
