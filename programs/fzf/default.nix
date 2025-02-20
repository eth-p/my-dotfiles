# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/junegunn/fzf
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.fzf;
in
{
  options.my-dotfiles.fzf = with lib; {
    enable = mkEnableOption "install and configure fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      enableFishIntegration = false;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };

    xdg.configFile."fish/conf.d/load-fzf-key-bindings.fish" = {
      text = ''
        # This disables fzf's force-installed key bindings.
      '';
    };
  };
}
