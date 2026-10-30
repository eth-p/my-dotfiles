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
  cfg = config.my-dotfiles.programs.kubectl;

in
{
  options.my-dotfiles.programs.kubectl = {

    serverSideApply = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "use server-side apply by default";
    };

  };

  config = mkMerge [

    # Default to using server-side apply instead of client-side.
    (mkIf cfg.serverSideApply {
      my-dotfiles.programs.kubectl.extraDefaults = {
        apply.options.server-side = "true";
      };
    })

  ];
}
