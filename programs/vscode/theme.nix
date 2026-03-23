# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  config,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg;
in
{
  options.my-dotfiles.vscode = {
    colorscheme = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
        "auto"
      ];
      default = config.my-dotfiles.global.colorscheme;
      description = "The color scheme used for Visual Studio Code.";
    };

    colorschemes =
      let
        themeType = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "the name of the theme as it would appear in Visual Studio Code.";
            };
            extensions = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              description = "extensions needed for the theme to be available";
            };
          };
        };
      in
      {
        dark = lib.mkOption {
          type = themeType;
          description = "The theme used for the dark color scheme";
          default = {
            name = "Dark (Molokai)";
            extensions = with extensions; [ nonylene.dark-molokai-theme ];
          };
        };

        light = lib.mkOption {
          type = themeType;
          description = "The theme used for the light color scheme";
          default = {
            name = "Default Light Modern";
            extensions = [ ];
          };
        };
      };
  };

  config = mkIf cfg.enable (mkMerge [

    # Set up colorschemes.
    {
      programs.vscode.profiles.default = {
        extensions = cfg.colorschemes.dark.extensions ++ cfg.colorschemes.light.extensions;
        userSettings = {
          "window.autoDetectColorScheme" = (cfg.colorscheme == "auto");
          "workbench.preferredLightColorTheme" = cfg.colorschemes.light.name;
          "workbench.preferredDarkColorTheme" = cfg.colorschemes.dark.name;
        };
      };
    }

    (mkIf (cfg.colorscheme != "auto") {
      programs.vscode.profiles.default.userSettings = {
        "workbench.colorTheme" = cfg.colorschemes."${cfg.colorscheme}".name;
      };
    })

    # Set up fonts.
    (
      let
        inherit (config.my-dotfiles.global) font-category;
        defaultFonts = "Menlo, Monaco, 'Courier New', monospace";
      in
      {
        home.packages = [
          font-category.code.package
          font-category.terminal.package
        ];

        programs.vscode.profiles.default.userSettings = {
          "editor.fontFamily" = "'${font-category.code.family-name}', ${defaultFonts}";
          "terminal.integrated.fontFamily" = "'${font-category.terminal.family-name}', ${defaultFonts}";
        };
      }
    )

  ]);
}
