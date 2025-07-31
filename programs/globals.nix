# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This contains global options used throughout my home-manager modules.
# ==============================================================================
{ config, lib, pkgs, ... }:
let
  fontType = lib.types.submodule {
    options = {
      package = lib.mkOption {
        type = lib.types.package;
        description = "the package to install the font";
      };
      family-name = lib.mkOption {
        type = lib.types.str;
        description = "the font family name";
        example = "JetBrainsMono Nerd Font";
      };
    };
  };
in
with lib; {
  options.my-dotfiles.global = {

    nerdfonts = mkEnableOption "NerdFonts are supported and installed";

    font-category = {
      code = mkOption {
        type = fontType;
        description = "the monospace font family used for displaying code.";
        default = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          family-name = "JetBrainsMonoNL Nerd Font";
        };
      };
      terminal = mkOption {
        type = fontType;
        description = "the monospace font family used for the terminal.";
        default = config.my-dotfiles.global.font-category.code;
      };
    };

    colorscheme = mkOption {
      type = types.enum [ "dark" "light" "auto" ];
      default = "auto";
      description = ''
        The general color scheme used throughout various programs.
      '';
    };

  };
}
