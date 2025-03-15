# NixOS Module Options


## [`options.my-dotfiles.bat.enable`](programs/bat/default.nix#L13)

install and configure bat

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.bat.enableBatman`](programs/bat/default.nix#L15)

Enable batman for reading manpages.

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.btop.enable`](programs/btop/default.nix#L13)

install and configure btop

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.carapace.enable`](programs/carapace/default.nix#L13)

install and configure carapace

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.devenv.enable`](programs/devenv/default.nix#L14)

install devenv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.devenv.inPrompt`](programs/devenv/default.nix#L15)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.direnv.enable`](programs/direnv/default.nix#L13)

install direnv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.direnv.hideDiff`](programs/direnv/default.nix#L15)

hide the environment variable diff

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.eza.enable`](programs/eza/default.nix#L15)

install and configure eza as a replacement for ls

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.eza.enableAliases`](programs/eza/default.nix#L23)

Enable shell aliases.

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.eza.theme`](programs/eza/default.nix#L17)

the theme to use

**Type:** `lib.types.enum themes.all`

**Default:** `"base16"`

## [`options.my-dotfiles.fd.enable`](programs/fd/default.nix#L13)

install and configure fd

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.fd.ignoreGitRepoFiles`](programs/fd/default.nix#L21)

Ignore files inside .git

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.fd.ignoreMacFiles`](programs/fd/default.nix#L15)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`options.my-dotfiles.fish.enable`](programs/fish/default.nix#L13)

install and configure fish

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.fish.isSHELL`](programs/fish/default.nix#L15)

use as `$SHELL`

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.fzf.enable`](programs/fzf/default.nix#L13)

install and configure fzf

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.git.enable`](programs/git/default.nix#L14)

install and configure git

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.git.fzf.fixup`](programs/git/default.nix#L20)

Add `git fixup` command

**Type:** `lib.types.bool`

**Default:** `false`

## [`options.my-dotfiles.git.github`](programs/git/default.nix#L17)

install the gh command-line tool

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.git.ignoreMacFiles`](programs/git/default.nix#L39)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`options.my-dotfiles.git.inPrompt`](programs/git/default.nix#L15)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.git.useDelta`](programs/git/default.nix#L27)

Use delta to show diffs.

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.git.useDyff`](programs/git/default.nix#L33)

Use dyff to show diffs between YAML files.

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.glow.enable`](programs/glow/default.nix#L15)

install glow

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.glow.theme`](programs/glow/default.nix#L17)

the theme to use

**Type:** `lib.types.enum (themes.all)`

**Default:** `"base16"`

## [`options.my-dotfiles.neovim.enable`](programs/neovim/default.nix#L15)

neovim

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.neovim.integrations.git`](programs/neovim/default.nix#L35)

Enable git integrations.

**Type:** `lib.types.bool`

**Default:** `config.programs.git.enable`

## [`options.my-dotfiles.neovim.ui.focus_dimming`](programs/neovim/default.nix#L23)

Dim unfocused panes.

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.neovim.ui.nerdfonts`](programs/neovim/default.nix#L17)

Enable support for using Nerdfonts.

**Type:** `lib.types.bool`

**Default:** `false`

## [`options.my-dotfiles.neovim.ui.transparent_background`](programs/neovim/default.nix#L29)

Use a transparent background.

**Type:** `lib.types.bool`

**Default:** `false`

## [`options.my-dotfiles.oh-my-posh.enable`](programs/oh-my-posh/default.nix#L16)

install and configure oh-my-posh

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.oh-my-posh.envAnnotations`](programs/oh-my-posh/default.nix#L24)

**Type:** `lib.types.attrsOf lib.types.attrs`

**Default:** `{ }`

**Example:**

```nix
{
  something = {
    style = "diamond";
    leading_diamond = " ";
    trailing_diamond = "";
    type = "text";
    background = "red";
    template = " foo ";
  };
}
```

## [`options.my-dotfiles.oh-my-posh.newline`](programs/oh-my-posh/default.nix#L18)

user text is entered on a new line

**Type:** `lib.types.bool`

**Default:** `true`

## [`options.my-dotfiles.oh-my-posh.pathAnnotations`](programs/oh-my-posh/default.nix#L39)

**Type:** `lib.types.attrsOf lib.types.attrs`

**Default:** `{ }`

**Example:**

```nix
{
  something = {
    style = "diamond";
    leading_diamond = " ";
    trailing_diamond = "";
    type = "text";
    background = "red";
    template = " foo ";
  };
}
```

## [`options.my-dotfiles.ranger.enable`](programs/ranger/default.nix#L15)

install and configure ranger

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.ranger.glow.forOpen`](programs/ranger/default.nix#L18)

use glow to open markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.ranger.glow.forPreview`](programs/ranger/default.nix#L19)

use glow to preview markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.ripgrep.enable`](programs/ripgrep/default.nix#L13)

install ripgrep

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.my-dotfiles.zoxide.enable`](programs/zoxide/default.nix#L13)

install and configure zoxide

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`options.programs.ranger.scope.extension`](programs/ranger/patch-scope-options.nix#L31)

**Type:** `lib.types.listOf bashCase`

**Default:** `[ ]`

## [`options.programs.ranger.scope.imageType`](programs/ranger/patch-scope-options.nix#L39)

**Type:** `lib.types.listOf bashCase`

**Default:** `[ ]`

## [`options.programs.ranger.scope.mimeType`](programs/ranger/patch-scope-options.nix#L35)

**Type:** `lib.types.listOf bashCase`

**Default:** `[ ]`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
