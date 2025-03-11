# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/sharkdp/fd
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.fd;
in
{
  options.my-dotfiles.fd = {
    enable = lib.mkEnableOption "install and configure fd";

    ignoreMacFiles = lib.mkOption {
      type = lib.types.bool;
      description = "Ignore system files created by MacOS.";
      default = pkgs.stdenv.isDarwin;
    };

    ignoreGitRepoFiles = lib.mkOption {
      type = lib.types.bool;
      description = "Ignore files inside .git";
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure fd.
    {
      programs.fd = {
        enable = true;
      };
    }

    # Configure ignore rules for Mac.
    (mkIf cfg.ignoreMacFiles {
      programs.fd.ignores = [
        ".DS_Store"
        "._*"
      ];
    })

    # Configure ignore rules for files under `./git`.
    (mkIf cfg.ignoreGitRepoFiles {
      programs.fd.ignores = [
        ".git/**"
      ];
    })

  ]);
}
