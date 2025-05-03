# my-dotfiles

My configuration management solution based on Nix and home-manager.



## Options

See [OPTIONS.md](./OPTIONS.md).



## Usage

### Directly

**Installation:**

```bash
./scripts/bootstrap
```

**Updates:**

```bash
git pull
./scripts/my-dotfiles
```

<details>
<summary>Or, manually.</summary>

```bash
cd /path/to/my-dotfiles
git pull

cd ~/.local/my-dotfiles/config
profile=standard
nix flake update
nix shell 'home-manager' --command 'home-manager' switch --flake "path:.#${profile}"
```

</details>


### As a Flake

My dotfiles flake can also be used as a library, allowing for separate
configurations in private repositories.

```nix
# flake.nix
# TODO
```
