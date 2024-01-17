# SteamOS

My dotfiles now support various tweaks and tricks for SteamOS on the Steam Deck!

## Tweaks

### steamos-chrome

Installs Google Chrome along with a couple tweaks to better support running under desktop mode.

- KDE Plasma workspace log-out hook to ensure graceful shutdown.
- Chrome flags to use dark mode.
- Chrome flags to improve performance.

### steamos-gpg

A `systemd` service and wrapper around `gpg` which allows GnuPG and the `gpg-agent` to operate on files stored within a Plasma Vault. If the vault is locked whenever `gpg` is executed, the user will be asked to unlock the vault first.

The vault should be named `Identity` and contain a `gnupg` directory to store the user's keyring.
This can also be used for SSH keys, allowing for a relatively-secure way to store auth credentials.

### steamos-shortcuts

A couple executable scripts that fix issues with running third-party software under the Steam Deck's gamemode session.

- `/home/deck/.local/steam-shortcuts/gamemode-discord`  
  Starts Flatpak Discord and also closes it properly.  
  Create a non-Steam shortcut for Discord and replace it to point to this script.

### steamos-vscode

Install Visual Studio Code's flatpak and (with a little bit of configuration) enables running the user's unsandboxed shell.

Please add the following terminal profile to Visual Studio Code's configuration:

```jsonc
// ...
"terminal.integrated.profiles.linux": {
  "Host": {
    "overrideName": true,
    "icon": "terminal-linux",
    "path": "/bin/bash",
    "args": [
      "-c",
      "export FLATPAK_INSTANCE=$(grep 'instance-id=' /run/user/1000/.flatpak/*/info | cut -d'=' -f2); host-spawn -env TERM,FLATPAK_ID,FLATPAK_INSTANCE fish -l",
    ]
  }
}
```