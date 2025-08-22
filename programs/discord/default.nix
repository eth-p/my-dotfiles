# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://discord.com/
# ==============================================================================
{ lib, config, pkgs, ... }@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.discord;
in
{
  options.my-dotfiles.discord = {
    enable = lib.mkEnableOption "enable Discord config";

    supported = lib.mkOption {
      readOnly = true;
      type = lib.types.bool;
      description = "whether Discord is supported on the current platform";
      default = pkgs.stdenv.isLinux;
    };

    source = lib.mkOption {
      type = lib.types.enum [ "flatpak" ];
      description = "the installation source for Discord";
      default = "flatpak";
    };

    betterdiscord = { enable = lib.mkEnableOption "install BetterDiscord"; };
  };

  config =
    let
      sources = {
        flatpak = {
          configDir = config.home.homeDirectory
            + "/.var/app/com.discordapp.Discord/config";
        };
      };

      inherit (sources."${cfg.source}") configDir;
    in
    mkIf (cfg.supported && cfg.enable) (mkMerge [

      # Install BetterDiscord by wrapping the .desktop file.
      (mkIf cfg.betterdiscord.enable {
        home.packages = [ pkgs.betterdiscordctl ];
      })

      (mkIf (cfg.betterdiscord.enable && cfg.source == "flatpak") (
        let
          wrapper =
            pkgs.writeShellApplication
              {
                name = "discord-betterdiscord-flatpak-wrapper";
                runtimeInputs = [ pkgs.betterdiscordctl ];

                text = ''
                  if betterdiscordctl -i flatpak status | grep 'no$'; then
                    betterdiscordctl -i flatpak install
                  fi

                  flatpak run --branch=stable \
                    --arch=${pkgs.stdenv.targetPlatform.linuxArch} \
                    --command=com.discordapp.Discord \
                    --file-forwarding \
                    com.discordapp.Discord "$@"
                '';
              };
        in
        {
          # Flatpak has XDG_DATA_DIRS higher priority than `~/.nix-profile`.
          # As a workaround, we'll just write it directly to `~/.local`.
          home.file.".local/share/applications/com.discordapp.Discord.desktop" = {
            text = ''
              [Desktop Entry]
              Name=Discord
              StartupWMClass=discord
              Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
              GenericName=Internet Messenger
              Exec=${wrapper}/bin/${wrapper.name} @@u %U @@
              Icon=com.discordapp.Discord
              Type=Application
              Categories=Network;InstantMessaging;
              Path=/usr/bin
              X-Desktop-File-Install-Version=0.28
              MimeType=x-scheme-handler/discord;
              X-Flatpak-Tags=proprietary;
              X-Flatpak=com.discordapp.Discord
            '';
          };
        }
      ))

    ]);
}
