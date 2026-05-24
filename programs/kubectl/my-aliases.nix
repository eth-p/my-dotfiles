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
  options.my-dotfiles.kubectl = {

    alias.ls.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "alias to list resources by name";
    };

  };

  config = mkMerge [

    # Alias provided by my-dotfiles: `kubectl ls`
    (mkIf cfg.alias.ls.enable {
      my-dotfiles.kubectl.extraAliases.ls = {
        enable = lib.mkDefault true;
        description = lib.mkDefault "list resources by name";
        command = "get";
        options = {
          output = "name";
        };
      };
    })

  ];
}
