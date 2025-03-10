# my-dotfiles

My newer configuration management solution based on Nix and home-manager.



## Installation

```bash
./scripts/bootstrap
```



## Updates

With the helper script:

```bash
my-dotfiles "standard"
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


## Options

See [OPTIONS.md](./OPTIONS.md).
