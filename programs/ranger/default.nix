# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/ranger/ranger
# ==============================================================================
{ lib, config, pkgs, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  rangerHome = "${config.xdg.configHome}/ranger";
  cfg = config.my-dotfiles.ranger;
  themes = (import ./themes.nix inputs);
in
{
  options.my-dotfiles.ranger = {
    enable = lib.mkEnableOption "install and configure ranger";

    glow = {
      forOpen = lib.mkEnableOption "use glow to open markdown files";
      forPreview = lib.mkEnableOption "use glow to preview markdown files";
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure ranger.
    {
      programs.ranger = {
        enable = true;
        settings = {
          # Theme.
          colorscheme = "base16";
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
    }

    # Add ranger themes.
    {
      home.file = builtins.listToAttrs (
        builtins.map
          (theme: {
            name = "${rangerHome}/colorschemes/${theme}.py";
            value = {
              source = ./themes + "/${theme}.py";
            };
          })
          themes.custom
      );
    }

    # Add zoxide integration.
    (mkIf config.my-dotfiles.zoxide.enable {
      programs.ranger.plugins = [
        {
          name = "ranger-zoxide";
          src = builtins.fetchGit {
            url = "https://github.com/jchook/ranger-zoxide";
            rev = "281828de060299f73fe0b02fcabf4f2f2bd78ab3";
          };
        }
      ];
    })

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

    (mkIf cfg.glow.forPreview (
      let
        glowThemes = (import ../glow/themes.nix inputs);
        glowTheme = config.my-dotfiles.glow.theme;
        styleFlag =
          if config.my-dotfiles.glow.enable
          then "--style=${builtins.toJSON (glowThemes.toFlag glowTheme)}"
          else "--style=dark";
      in
      {
        home.packages = [ pkgs.glow ];
        programs.ranger.scope.extension = [
          {
            case = "md|markdown";
            command = ''
              CLICOLOR_FORCE=1 glow "$FILE_PATH" ${styleFlag} --width="$PV_WIDTH" && exit 0
            '';
          }
        ];
      }
    ))

    # Config for opening files.
    {
      programs.ranger.rifle = [
        # Edit any text in the editor.
        {
          condition = "mime ^text, label editor";
          command = "\${VISUAL:-$EDITOR} -- $@";
        }
        {
          condition = "!mime ^text, label editor, ext json";
          command = "\${VISUAL:-$EDITOR} -- $@";
        }
        # Open any text in the pager.
        {
          condition = "mime ^text, label pager";
          command = "\${PAGER} -- $@";
        }
        {
          condition = "!mime ^text, label pager, ext json";
          command = "\${PAGER} -- $@";
        }
      ];
    }

  ]);
}
