# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  config,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg;
in
{
  options.my-dotfiles.vscode = {
    config.allowedLinkSchemes = {
      includeDefaults = lib.mkOption {
        type = lib.types.bool;
        description = "Include the default hyperlink schemes that are allowed to be opened.";
        default = true;
      };

      extras = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Extra hyperlink schemes that are allowed to be opened.";
        default = [ ];
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [

    # Configure the terminal.
    {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.macOptionIsMeta" = true;
        "terminal.integrated.allowedLinkSchemes" =
          cfg.config.allowedLinkSchemes.extras
          ++ (lib.optional cfg.config.allowedLinkSchemes.includeDefaults [
            "file"
            "http"
            "https"
            "mailto"
            "vscode"
            "vscode-insiders"
          ]);
      };
    }

    # Disable the Kitty Keyboard protocol. It's broken in versions < 1.111.1
    # https://github.com/microsoft/vscode/issues/302524
    {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.enableKittyKeyboardProtocol" = false;
      };
    }

  ]);
}
