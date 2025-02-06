# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/neovim/neovim
# ==============================================================================
{ lib, pkgs, config, my-dotfiles, ... } @ inputs:
let
  inherit (my-dotfiles.lib) tolua;
  cfg = config.my-dotfiles.neovim;
  nvimHome = "${config.xdg.configHome}/nvim";
in
{
  options.my-dotfiles.neovim = with lib; {
    enable = mkEnableOption "neovim";

    ui.nerdfonts = mkOption {
      type = types.bool;
      description = "Enable support for using Nerdfonts.";
      default = false;
    };

    ui.focus_dimming = mkOption {
      type = types.bool;
      description = "Dim unfocused panes.";
      default = true;
    };

    ui.transparent_background = mkOption {
      type = types.bool;
      description = "Use a transparent background.";
      default = false;
    };

    integrations.git = mkOption {
      type = types.bool;
      description = "Enable git integrations.";
      default = config.programs.git.enable;
    };
  };

  config = lib.mkIf cfg.enable {

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
            ui = cfg.ui;
            integrations = cfg.integrations;
          }}
        '';
      };
    };

  };
}
