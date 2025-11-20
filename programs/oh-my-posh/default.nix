# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# (This is used for my shell prompts)
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.oh-my-posh;
  cfgGlobal = config.my-dotfiles.global;
  generator = (import ./generator.nix) inputs;

in
{
  options.my-dotfiles.oh-my-posh = {
    enable = lib.mkEnableOption "install and configure oh-my-posh";

    newline = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "user text is entered on a new line";
    };

    envAnnotations = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
      example = {
        something = {
          style = "diamond";
          leading_diamond = " ";
          trailing_diamond = "";
          type = "text";
          background = "red";
          template = " foo ";
        };
      };
    };

    pathAnnotations = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
      example = {
        something = {
          style = "diamond";
          leading_diamond = " ";
          trailing_diamond = "";
          type = "text";
          background = "red";
          template = " foo ";
        };
      };
    };

    extraBlocks = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
    };
  };

  # Configure oh-my-posh.
  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      package = lib.mkDefault pkgs.oh-my-posh;
      settings = {
        version = 3;
        final_space = !cfg.newline;
        shell_integration = true;
        blocks = generator.mkBlocks (
          (import ./prompt (
            inputs
            // {
              inherit cfg;
              inherit generator;
            }
          ))
          // cfg.extraBlocks
        );
        palettes = {
          template =
            if cfgGlobal.colorscheme == "auto" then
              "{{ .Env.PREFERRED_COLORSCHEME | default \"dark\" }}"
            else
              cfgGlobal.colorscheme;
          list = (import ./colors.nix);
        };
      };
    };
  };
}
