# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Patch to make ranger's scope.sh configurable. 
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.programs.ranger;

  bashCase = with lib; types.submodule {
    options = {
      case = mkOption {
        type = types.str;
        description = ''
          The case expression.
        '';
      };
      command = mkOption {
        type = types.lines;
        description = ''
          The command to run if this branch is taken.
        '';
      };
    };
  };
in
{
  options.programs.ranger = with lib; {
    scope = {
      extension = mkOption {
        type = types.listOf bashCase;
        default = [ ];
      };
      mimeType = mkOption {
        type = types.listOf bashCase;
        default = [ ];
      };
      imageType = mkOption {
        type = types.listOf bashCase;
        default = [ ];
      };
    };
  };

  config =
    let
      hasExtensionCases = (builtins.length cfg.scope.extension) > 0;
      hasMimeTypeCases = (builtins.length cfg.scope.mimeType) > 0;
      hasImageTypeCases = (builtins.length cfg.scope.imageType) > 0;
      isEnabled = cfg.enable && (hasExtensionCases || hasMimeTypeCases || hasImageTypeCases);
    in
    mkIf isEnabled {

      # Set the preview script to our patched version.
      programs.ranger.settings = {
        preview_script = "${config.xdg.configHome}/ranger/scope.sh";
      };

      # Patch the preview script.
      home.file."${config.xdg.configHome}/ranger/scope.sh" =
        let
          rangerSrc = pkgs.ranger.src.outPath;
          createCase = { case, command }: "${case})\n    ${command}\n    ;;\n";
          createCases = cs: builtins.concatStringsSep "\n" (builtins.map createCase cs);
          createInject = cs: "# added by nix\n${createCases cs}\n# /added by nix\n\n";

          # Strings to be replaced when patching scope.sh:
          subst_extension = ''
            handle_extension() {
                case "''${FILE_EXTENSION_LOWER}" in
          '';

          subst_mime = ''
            handle_mime() {
                local mimetype="''${1}"
                case "''${mimetype}" in
          '';

          subst_image = ''
            ${"    "}local DEFAULT_SIZE="1920x1080"
            ${"    "}
            ${"    "}local mimetype="''${1}"
            ${"    "}case "''${mimetype}" in
          '';

        in
        {
          executable = true;
          text = builtins.replaceStrings
            [ subst_extension subst_mime subst_image ]
            [
              "${subst_extension}\n${createInject cfg.scope.extension}"
              "${subst_mime}\n${createInject cfg.scope.mimeType}"
              "${subst_image}\n${createInject cfg.scope.imageType}"
            ]
            (builtins.readFile "${rangerSrc}/ranger/data/scope.sh");
        };

    };
}
