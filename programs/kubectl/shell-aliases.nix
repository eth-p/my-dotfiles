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
  cfg = config.my-dotfiles.kubectl;

in
{
  imports = [
    ./my-aliases.nix
    ./my-defaults.nix
  ];

  options.my-dotfiles.kubectl = {
    enableShellAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "add shell aliases and abbreviations for kubectl commands";
    };

    enableFishAliases = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enableShellAliases;
      description = "add fish shell aliases and abbreviations for kubectl commands";
    };
  };

  config = mkIf (cfg.enable && cfg.enableShellAliases) (mkMerge [

    # Fish shell aliases and abbreviations.
    (mkIf cfg.enableFishAliases {
      programs.fish = {
        shellAliases = {
          k = "kubectl";
          kg = "kubectl get";
          kgo = "kubectl get -oyaml";
          kd = "kubectl describe";
          klog = "kubectl logs";
        };
        shellAbbrs = {
          "--failed" = {
            command = "kg";
            expansion = "--field-selector=status.successful=0";
          };
        };
        functions = {
          kgo = {
            wraps = "kubectl get";
            body = ''
              if command -q yq
                kubectl get -oyaml $argv | yq .
              else
                kubectl get $argv
              end
            '';
          };
        };
      };
    })

  ]);
}
