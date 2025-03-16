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

  config = mkIf cfg.enable {

    # Configure neovim.
    programs.neovim = {
      enable = true;
      viAlias = true; # Symlink `vi` to `nvim`
      defaultEditor = true; # Use neovim as $EDITOR
      extraLuaConfig = (builtins.readFile ./init.lua);
    };

    # Add neovim configuration.
    home.file = {
      "${nvimHome}/lua/eth-p" = {
        source = ./lua/eth-p;
        recursive = true;
      };

      "${nvimHome}/managed-by-nix.lua" = {
        text = ''
          return ${tolua.attrs {
            ui = cfg.ui // {
              colorscheme = cfg.colorschemes."${cfgGlobal.theme}";              
            };
            integrations = cfg.integrations;
          }}
        '';
      };
    };

  };
}
