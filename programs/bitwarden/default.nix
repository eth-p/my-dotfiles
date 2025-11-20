# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://bitwarden.com/
# ==============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkDefault;
  cfg = config.my-dotfiles.bitwarden;
in
{
  options.my-dotfiles.bitwarden = {
    enable = lib.mkEnableOption "install Bitwarden";
    useForSSHAgent = lib.mkEnableOption "use Bitwarden as the ssh-agent";
  };

  config = lib.mkIf cfg.enable (mkMerge [

    {
      home.packages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
      ];
    }

    # Use Bitwarden as the SSH Agent.
    (mkIf (cfg.enable && cfg.useForSSHAgent) {
      home.sessionVariables.SSH_AUTH_SOCK = config.home.homeDirectory + "/.bitwarden-ssh-agent.sock";
    })

  ]);
}
