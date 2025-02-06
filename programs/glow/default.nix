# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/charmbracelet/glow
# ==============================================================================
{ lib, pkgs, config, ctx, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf strings attrsets;
  cfg = config.my-dotfiles.glow;
  glowHome = "${config.xdg.configHome}/glow";
  styles = (import ./styles.nix inputs);
in
{
  options.my-dotfiles.glow = with lib; {
    enable = mkEnableOption "install glow";

    style = mkOption {
      type = types.enum (styles.all);
      description = "the style to use";
      default = "base16";
    };
  };

  config = mkIf cfg.enable {

    # Install glow.
    home.packages = [
      pkgs.glow
    ];

    # Configure glow.
    home.file = {
      "${glowHome}/glow.yml" =
        {
          text = ''
            style: ${builtins.toJSON (styles.toFlag cfg.style)}
            mouse: true
            pager: true
          '';
        };
    }

    # Add the custom style files.
    // (builtins.listToAttrs (
      builtins.map
        (style: {
          name = "${glowHome}/styles/${style}.json";
          value = {
            source = ./styles + "/${style}.json";
          };
        })
        styles.custom)
    );

  };
}
