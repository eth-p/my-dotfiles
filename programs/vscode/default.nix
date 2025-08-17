# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.vscode;
  extensions = pkgs-unstable.vscode-extensions;
  extensionsDir = ".vscode/extensions";
in
{
  imports = [
    ./bindings-intellij.nix
    ./language-bash.nix
    ./language-go.nix
    ./language-makefile.nix
    ./language-markdown.nix
    ./language-nix.nix
    ./qol-github.nix
    ./qol-todo.nix
  ];

  options.my-dotfiles.vscode = {
    enable = lib.mkEnableOption "install and configure Visual Studio Code";
    onlyConfigure = lib.mkEnableOption "do not install Visual Studio Code, only configure it";
    editorconfig = lib.mkEnableOption "install the EditorConfig extension" // { default = true; };

    keybindings = lib.mkOption {
      type = lib.types.enum [ "default" "intellij" ];
      description = "use alternate keybindings";
      default = "default";
    };

    colorscheme = lib.mkOption {
      type = lib.types.enum [ "dark" "light" "auto" ];
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

    editor = {
      rulers = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        description = "Column numbers to draw a ruler at.";
        default = [ 80 120 ];
      };
      inlineBlame = lib.mkOption {
        type = lib.types.bool;
        description = "show the git blame as an inline hint";
        default = true;
      };
      whitespace.showTrailing = lib.mkOption {
        type = lib.types.bool;
        description = "Highlight trailing whitespace.";
        default = true;
      };
    };

    fhs = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        description = "Use a FHS environment for VS Code.";
        default = pkgs.stdenv.isLinux;
        readOnly = ! pkgs.stdenv.isLinux;
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        description = "Extra packages to install in the VS Code FHS. If FHS is disabled, this will install them to the user profile.";
        example = [ (pkgs: with pkgs; [ gcc rustc ]) ];
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install Visual Studio Code.
    (
      let mkPkgList = pkgs: builtins.foldl' (a: b: a ++ (b pkgs)) [ ] cfg.fhs.packages;

      in {
        programs.vscode = {
          enable = true;
          package =
            if cfg.fhs.enabled
            then (pkgs.vscode.fhsWithPackages mkPkgList)
            else (pkgs.vscode);

          mutableExtensionsDir = false;
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;

            userSettings = {
              "git.blame.editorDecoration.enabled" = cfg.editor.inlineBlame;
              "editor.rulers" = cfg.editor.rulers;
            };
          };
        };

        home.packages = if cfg.fhs.enabled then [ ] else (mkPkgList pkgs);

        nixpkgs.config.allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [ "vscode" "code" ];
      }
    )

    # Optionally set the Visual Studio Code package to an empty package.
    (mkIf cfg.onlyConfigure {
      programs.vscode.package = lib.mkOrder 1100 (pkgs.stdenv.mkDerivation {
        pname = "vscode";
        name = "vscode";
        version = "1.74.0"; # must be at least 1.74.0 for extensions.json to be generated
        unpackPhase = ":";
        buildPhase = ''
          mkdir $out
        '';
      });
    })

    # Set up colorschemes.
    {
      programs.vscode.profiles.default = {
        extensions = cfg.colorschemes.dark.extensions ++ cfg.colorschemes.dark.extensions;
        userSettings = {
          "window.autoDetectColorScheme" = (cfg.colorscheme == "auto");
          "workbench.preferredLightColorTheme" = cfg.colorschemes.light.name;
          "workbench.preferredDarkColorTheme" = cfg.colorschemes.dark.name;
        };
      };
    }

    (mkIf (cfg.colorscheme != "auto") {
      programs.vscode.profiles.default.userSettings = {
        "workbench.colorTheme" = cfg.colorschemes."${cfg.colorscheme}";
      };
    })

    # Set up fonts.
    (
      let inherit (config.my-dotfiles.global) font-category;
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

    # Install EditorConfig extension.
    # https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig
    (mkIf cfg.editorconfig {
      programs.vscode.profiles.default.extensions = with extensions;
        [
          editorconfig.editorconfig
        ];
    })

    # Install Trailing Whitespace extension.
    # https://marketplace.visualstudio.com/items?itemName=jkiviluoto.tws
    (mkIf cfg.editor.whitespace.showTrailing {
      programs.vscode.profiles.default.extensions =
        with extensions; [
          shardulm94.trailing-spaces
        ];

      programs.vscode.profiles.default.userSettings = {
        "trailing-spaces.backgroundColor" = "rgba(255, 0, 179, 0.3)";
        "trailing-spaces.borderColor" = "rgba(255, 88, 205, 0.15)";
      };
    })

    # Configure to use `fish` as the shell.
    (mkIf (config.my-dotfiles.fish.enable && config.my-dotfiles.fish.isSHELL) {
      programs.vscode.profiles.default.userSettings =
        let os = if pkgs.stdenv.isDarwin then "osx" else "linux";
        in {
          "terminal.integrated.defaultProfile.${os}" = "fish";
          "terminal.integrated.profiles.${os}" = {
            "fish" = {
              "path" = pkgs.fish + "/bin/fish";
              "icon" = "terminal-bash";
            };
          };
        };
    })

  ]);
}
