# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This contains global options used throughout my home-manager modules.
# ==============================================================================
{ lib, ... }: with lib; {
  options.my-dotfiles = {

    nerdfonts = mkEnableOption "NerdFonts are supported and installed";

    theme = mkOption {
      type = types.enum [ "dark" "light" ];
      default = "dark";
      description = ''
        The general theme used throughout various programs.
      '';
    };

  };
}
