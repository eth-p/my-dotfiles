# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://carapace.sh/
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.carapace;

  yamlFormat = pkgs.formats.yaml { };
in
{
  options.my-dotfiles.carapace = {
    enable = lib.mkEnableOption "install and configure carapace";

    overlays = lib.mkOption {
      type = lib.types.attrsOf yamlFormat.type;
      default = { };
      description = ''
        Completion overlays to install in the carapace config directory.
      '';
    };
  };

  config =
    let
      carapaceConfigPath =
        if pkgs.stdenvNoCC.hostPlatform.isDarwin then
          "Library/Application Support/carapace"
        else
          "${config.xdg.configHome}/carapace";

    in
    mkIf cfg.enable (mkMerge [

      # Configure carapace.
      {
        programs.carapace = {
          enable = true;
          enableFishIntegration = true;

          package = lib.mkDefault pkgs.carapace;
        };
      }

      # Install overlays.
      {
        home.file = (
          lib.mapAttrs' (name: value: {
            name = "${carapaceConfigPath}/overlays/${name}.yaml";
            value = {
              source = yamlFormat.generate "carapace-overlay-${name}" value;
            };
          }) cfg.overlays
        );
      }

    ]);
}
