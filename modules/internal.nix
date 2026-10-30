# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Internal settings that are set by modules to simplify cross-configuration.
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-dotfiles._internal;
in
with lib;
{
  options.my-dotfiles._internal = {
    shell.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      internal = true;
      visible = false;
      description = ''
        **INTERNAL USE ONLY — DO NOT SET**
        The default user shell.
      '';
    };

    shell.executable = lib.mkOption {
      type = lib.types.nullOr lib.types.pathInStore;
      internal = true;
      visible = false;
      default = lib.getExe cfg.shell.package;
      description = ''
        **INTERNAL USE ONLY — DO NOT SET**
        The main executable of the default user shell.
      '';
    };
  };

}
