# my-dotfiles

My configuration management solution based on Nix and home-manager.



## Options

See [OPTIONS.md](./OPTIONS.md).



## Usage

### Directly

**Installation:**

```bash
./management/bin/bootstrap
```

**Updates:**

```bash
git pull
my-dotfiles
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
{
  description = "My config.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    my-dotfiles = {
      url = "github:eth-p/my-dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, my-dotfiles, ... }: {

    homeConfigurations."me@machine" = my-dotfiles.lib.home.mkHomeConfiguration {
      system = "aarch64-darwin";
      modules = [
        {
          home.username = "me";
          home.homeDirectory = "/home/me";
          home.stateVersion = "24.11";

          # Program config goes here.
          my-dotfiles.fish.enable = true;
        }
      ];
    };

  };
}
```
