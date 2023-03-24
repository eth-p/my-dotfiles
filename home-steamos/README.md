# SteamOS

My dotfiles now support various tweaks and tricks for SteamOS on the Steam Deck!

## Tweaks

### steamos-gpg

A `systemd` service and wrapper around `gpg` which allows GnuPG and the `gpg-agent` to operate on files stored within a Plasma Vault.

The vault should be mounted as `/home/deck/.identity`, and contain a `gnupg` directory to store the user's keyring. This can also be used for SSH keys, allowing for a relatively-secure way to store auth credentials.

### steamos-shortcuts

A couple executable scripts that fix issues with running third-party software under the Steam Deck's gamemode session.

- `/home/deck/.local/steam-shortcuts/gamemode-discord`  
  Starts Flatpak Discord and also closes it properly.  
  Create a non-Steam shortcut for Discord and replace it to point to this script.
