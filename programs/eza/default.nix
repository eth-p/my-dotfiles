# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/eza-community/eza
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf strings attrsets;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  ezaHome = "${config.xdg.configHome}/eza";
  cfg = config.my-dotfiles.eza;

  # Read the available custom styles (themes).
  # These are the YAML files under `./styles` without the file extension.
  customStyles = builtins.map
    (strings.removeSuffix ".yaml")
    (builtins.attrNames (attrsets.filterAttrs
      (name: kind: kind == "regular" && (strings.hasSuffix ".yaml" name))
      (builtins.readDir ./styles)
    ));
in
{
  options.my-dotfiles.eza = with lib; {
    enable = mkEnableOption "install and configure eza as a replacement for ls";

    style = mkOption {
      type = types.enum ([ "default" ] ++ customStyles);
      description = "the style to use";
      default = "base16";
    };

    enableAliases = mkOption {
      type = types.bool;
      description = "Enable shell aliases.";
      default = true;
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure eza.
    {
      programs.eza = {
        enable = true;
        git = true; # uses libgit2

        enableBashIntegration = cfg.enableAliases;
        enableZshIntegration = cfg.enableAliases;
        enableFishIntegration = cfg.enableAliases;
        enableIonIntegration = cfg.enableAliases;
        enableNushellIntegration = cfg.enableAliases;
      };
    }

    # Set style.
    (mkIf (cfg.style != "default") {
      home.file."${ezaHome}/theme.yml" = {
        source = ./styles + "/${cfg.style}.yaml";
      };
    })

  ]);

}
