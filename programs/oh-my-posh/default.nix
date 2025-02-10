# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# (This is used for my shell prompts)
# ==============================================================================
{ lib, pkgs, config, ctx, ... } @ inputs:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.oh-my-posh;
  generator = (import ./generator.nix) inputs;

in
{
  options.my-dotfiles.oh-my-posh = with lib; rec {
    enable = mkEnableOption "install and configure oh-my-posh";

    newline = mkOption {
      type = types.bool;
      default = true;
      description = "user text is entered on a new line";
    };

    pathAnnotations = mkOption {
      type = types.attrsOf types.attrs; # TODO: Proper typing.
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
  };

  # Configure oh-my-posh.
  config = mkIf cfg.enable
    {
      programs.oh-my-posh = {
        enable = true;
        settings = {
          version = 3;
          final_space = false;
          blocks = generator.mkBlocks (
            import ./prompt
              (inputs // {
                inherit cfg;
                inherit generator;
              })
          );
          palette = {
            path_parent = "242";
            path_curdir = "default";
            path_bg = "238";
          };
        };
      };
    };
}
