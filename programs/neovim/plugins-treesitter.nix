# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/neovim/neovim
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib) tolua;
  cfg = config.my-dotfiles.neovim;
  cfgGlobal = config.my-dotfiles.global;
  nvimHome = "${config.xdg.configHome}/nvim";
in
{
  options.my-dotfiles.neovim.syntax = {
    yaml = lib.mkOption {
      type = lib.types.bool;
      description = "Enable yaml syntax support (treesitter).";
      default = false;
    };

    nix = lib.mkOption {
      type = lib.types.bool;
      description = "Enable nix syntax support (treesitter).";
      default = false;
    };
  };

  config =
    let
      # Mapping of syntax enable options to function adding the syntax plugin.
      syntaxes = {
        yaml = p: p.yaml;
        nix = p: p.nix;
      };

      # List of keys under `syntaxes` variable, including only enabled ones.
      syntaxesEnabled = builtins.filter (n: cfg.syntax."${n}") (builtins.attrNames syntaxes);

    in
    mkIf (cfg.enable && (builtins.length syntaxesEnabled) > 0) {

      # Install the nvim-treesitter plugin through nix.
      programs.neovim.plugins = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (n: syntaxes."${n}" p) syntaxesEnabled))
      ];

      # Run the nvim-treesitter setup function after other plugins.
      programs.neovim.extraLuaConfig = lib.mkOrder 2000 ''
        -- Set up nvim-treesitter plugin.
        require("nvim-treesitter.configs").setup {
          auto_install = false,
          highlight = {
            enable = true,
          },
        }
      '';

    };
}
