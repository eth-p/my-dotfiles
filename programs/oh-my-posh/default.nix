# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# (This is used for my shell prompts)
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.oh-my-posh;
  cfgGlobal = config.my-dotfiles.global;
  cfgPosh = config.programs.oh-my-posh;
  generator = (import ./generator.nix) inputs;

in
{
  options.my-dotfiles.oh-my-posh = {
    enable = lib.mkEnableOption "install and configure oh-my-posh";

    newline = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "user text is entered on a new line";
    };

    envAnnotations = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
      example = {
        something = {
          style = "diamond";
          leading_diamond = " ";
          trailing_diamond = "";
          type = "text";
          background = "red";
          template = " foo ";
        };
      };
    };

    pathAnnotations = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
      example = {
        something = {
          style = "diamond";
          leading_diamond = " ";
          trailing_diamond = "";
          type = "text";
          background = "red";
          template = " foo ";
        };
      };
    };

    extraBlocks = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs; # TODO: Proper typing.
      default = { };
    };
  };

  # Configure oh-my-posh.
  config = mkIf cfg.enable (mkMerge [
    {
      programs.oh-my-posh = {
        enable = true;
        package = lib.mkDefault pkgs.oh-my-posh;
        settings = {
          version = 3;
          final_space = !cfg.newline;
          shell_integration = true;
          blocks = generator.mkBlocks (
            (import ./prompt (
              inputs
              // {
                inherit cfg;
                inherit generator;
              }
            ))
            // cfg.extraBlocks
          );
          palettes = {
            template =
              if cfgGlobal.colorscheme == "auto" then
                "{{ .Env.PREFERRED_COLORSCHEME | default \"dark\" }}"
              else
                cfgGlobal.colorscheme;
            list = (import ./colors.nix);
          };
        };
      };

      programs.fish.shellAliases = {
        oh-my-posh-fix = "oh-my-posh init fish --config ~/.config/oh-my-posh/config.json | source";
      };
    }

    # Fix for the prompt theme being reset every time home-manager config is switched.
    (mkIf cfgPosh.enableFishIntegration (
      let
        universalVarName = "__ethp_dotfiles_oh_my_posh_cache_reload";

        # https://github.com/nix-community/home-manager/blob/fca4cba863e76c26cfe48e5903c2ff4bac2b2d5d/modules/programs/oh-my-posh.nix#L13C1-L22C10
        poshInitArgs =
          if cfgPosh.settings != { } then
            [
              "--config"
              "${config.xdg.configHome}/oh-my-posh/config.json"
            ]
          else if cfgPosh.useTheme != null then
            [
              "--config"
              "${cfgPosh.package}/share/oh-my-posh/themes/${cfgPosh.useTheme}.omp.json"
            ]
          else if cfgPosh.configFile != null then
            [
              "--config"
              "${cfgPosh.configFile}"
            ]
          else
            [ ];

      in
      {
        programs.fish = {
          interactiveShellInit = ''
            function __ethp_dotfiles_reload_oh_my_posh \
              --description "Reloads the oh-my-posh prompt config after home-manager switch" \
              --on-variable ${universalVarName}
              oh-my-posh init fish ''$${universalVarName}[2..] | source
            end
          '';
        };

        home.activation.ohMyPoshReloadFishPrompt = lib.hm.dag.entryAfter [ "ohMyPoshClearCache" ] ''
          ${config.programs.fish.package}/bin/fish -c 'set -U ${universalVarName} (date +%s) $argv' -- ${lib.strings.escapeShellArgs poshInitArgs}
        '';
      }
    ))
  ]);
}
