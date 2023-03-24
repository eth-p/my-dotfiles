# SteamOS

My dotfiles now support various tweaks and tricks for SteamOS on the Steam Deck!

## Tweaks

### steamos-gpg

A `systemd` service and wrapper around `gpg` which allows GnuPG and the `gpg-agent` to operate on files stored within a Plasma Vault.

The vault should be mounted as `/home/deck/.identity`, and contain a `gnupg` directory to store the user's keyring. This can also be used for SSH keys, allowing for a relatively-secure way to store auth credentials.
