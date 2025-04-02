# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/neovim/neovim
# ==============================================================================
{ lib, config, pkgs, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib) tolua;
  cfg = config.my-dotfiles.neovim;
  cfgGlobal = config.my-dotfiles.global;
  nvimHome = "${config.xdg.configHome}/nvim";
in
{
  imports = [
    ./plugins-treesitter.nix
  ];

  options.my-dotfiles.neovim = {
    enable = lib.mkEnableOption "neovim";

    colorschemes = {
      dark = lib.mkOption {
        type = lib.types.str;
        description = "The colorscheme used for dark mode.";
        default = "monokai-pro";
      };

      light = lib.mkOption {
        type = lib.types.str;
        description = "The colorscheme used for light mode.";
        default = "catppuccin-latte";
      };
    };

    ui.nerdfonts = lib.mkOption {
      type = lib.types.bool;
      description = "Enable support for using Nerdfonts.";
      default = cfgGlobal.nerdfonts;
    };

    ui.focus_dimming = lib.mkOption {
      type = lib.types.bool;
      description = "Dim unfocused panes.";
      default = true;
    };

    ui.transparent_background = lib.mkOption {
      type = lib.types.bool;
      description = "Use a transparent background.";
      default = false;
    };

    integrations.git = lib.mkOption {
      type = lib.types.bool;
      description = "Enable git integrations.";
      default = config.programs.git.enable;
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure neovim.
    {
      programs.neovim = {
        enable = true;
        viAlias = true; # Symlink `vi` to `nvim`
        defaultEditor = true; # Use neovim as $EDITOR
        extraLuaConfig = (builtins.readFile ./init.lua);
      };

      home.file = {
        # Add neovim configuration.
        "${nvimHome}/lua/eth-p" = {
          source = ./lua/eth-p;
          recursive = true;
        };

        # Generate config for options/plugins managed by nix.
        #
        # Prefer adding plugins through Lazy.nvim configuration to support
        # lazy loading, except when plugins rely on native binaries or libraries.
        "${nvimHome}/managed-by-nix.lua" =
          let
            managedOptions = {
              integrations = cfg.integrations;
              ui = cfg.ui // {
                colorscheme =
                  if cfgGlobal.colorscheme != "auto"
                  then cfg.colorschemes."${cfgGlobal.colorscheme}"
                  else null;

                colorschemes = {
                  dark = cfg.colorschemes.dark;
                  light = cfg.colorschemes.light;
                };
              };
            };

            # home-manager neovim adds plugins the `finalPackage.packpathDirs`.
            packpathDirs = config.programs.neovim.finalPackage.packpathDirs;
            packpathInStore = pkgs.neovimUtils.packDir packpathDirs;

            # Reading the output dir gives us the list of loadable plugins.
            builtPluginsPath = packpathInStore + "/pack/myNeovimPackages/start";
            builtPluginNames = builtins.attrNames (builtins.readDir builtPluginsPath);

            managedPlugins =
              if (builtins.length packpathDirs.myNeovimPackages.start > 0)
              then builtPluginNames
              else [ ];

            mkLazyNvimSpecForManagedPlugin = name: {
              name = name + " (via nix)";
              dir = builtPluginsPath + "/" + name;
              lazy = false;
            };

          in
          {
            text = ''
              return ${tolua.attrs {
                plugins = (map mkLazyNvimSpecForManagedPlugin managedPlugins);
                opts = managedOptions;
              }}
            '';
          };
      };
    }
  ]);
}
