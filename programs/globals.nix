# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This contains global options used throughout my home-manager modules.
# ==============================================================================
{ lib, ... }: with lib; {
  options.my-dotfiles.global = {

    nerdfonts = mkEnableOption "NerdFonts are supported and installed";

    colorscheme = mkOption {
      type = types.enum [ "dark" "light" "auto" ];
      default = "auto";
      description = ''
        The general color scheme used throughout various programs.
      '';
    };

  };
}
