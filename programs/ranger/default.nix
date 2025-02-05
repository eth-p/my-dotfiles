# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# My ranger configuration.
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  rangerHome = "${config.xdg.configHome}/ranger";
  cfg = config.my-dotfiles.ranger;
in
{
  options.my-dotfiles.ranger = with lib; {
    enable = mkEnableOption "install and configure ranger";

    glow = {
      forOpen = mkEnableOption "use glow to open markdown files";
      forPreview = mkEnableOption "use glow to preview markdown files";
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure ranger.
    {
      programs.ranger = {
        enable = true;
        settings = {
          # Theme.
          colorscheme = "monokai";
          status_bar_on_top = false;
          draw_progress_bar_in_status_bar = true;
          draw_borders = "separators";

          # Previews.
          preview_files = true;
          preview_directories = true;
          collapse_preview = false;

          use_preview_script = true;

          # UI.
          tilde_in_titlebar = true;
          column_ratios = "3,5,8";

          # General.
          mouse_enabled = true;
          hidden_filter = "^\\.|\\.(?:pyc|pyo|bak|swp)$|^lost\\+found$|^__(py)?cache__$";
        };

        mappings = {
          zc = "chain set collapse_preview!;set preview_files!;set preview_directories!";
          zg = "set vcs_aware!";
        };
      };

      home.file = {
        "${rangerHome}/colorschemes/monokai.py" = {
          source = ./colorschemes/monokai.py;
        };
      };
    }

    # Add git integration.
    (mkIf config.my-dotfiles.git.enable {
      programs.ranger = {
        settings.vcs_aware = true;
        settings.vcs_backend_git = "local";
      };
    })

    # Add glow support.
    (mkIf cfg.glow.forOpen {
      home.packages = [ pkgs.glow ];
      programs.ranger.rifle = [
        {
          condition = "ext (md|markdown), has glow";
          command = "LESS=-R LESSCHARSET=utf-8 glow --pager \"$@\"";
        }
      ];
    })

    (mkIf cfg.glow.forPreview {
      home.packages = [ pkgs.glow ];
      programs.ranger.scope.extension = [
        {
          case = "md|markdown";
          command = ''
            CLICOLOR_FORCE=1 glow "$FILE_PATH" --style=dark --width="$PV_WIDTH" && exit 0
          '';
        }
      ];
    })

  ]);
}
