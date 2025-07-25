# NixOS Module Options


## [`my-dotfiles.bat.enable`](programs/bat/default.nix#L13)

install and configure bat

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.bat.enableBatman`](programs/bat/default.nix#L15)

Enable batman for reading manpages.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.btop.enable`](programs/btop/default.nix#L13)

install and configure btop

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.carapace.enable`](programs/carapace/default.nix#L13)

install and configure carapace

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.devenv.enable`](programs/devenv/default.nix#L15)

install devenv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.devenv.inPrompt`](programs/devenv/default.nix#L16)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.direnv.enable`](programs/direnv/default.nix#L13)

install direnv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.direnv.hideDiff`](programs/direnv/default.nix#L15)

hide the environment variable diff

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.betterdiscord.enable`](programs/discord/default.nix#L28)

install BetterDiscord

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.enable`](programs/discord/default.nix#L13)

enable Discord config

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.source`](programs/discord/default.nix#L22)

the installation source for Discord

**Type:** `lib.types.enum [ "flatpak" ]`

**Default:** `"flatpak"`

## [`my-dotfiles.discord.supported`](programs/discord/default.nix#L15)

whether Discord is supported on the current platform

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isLinux`

## [`my-dotfiles.eza.enable`](programs/eza/default.nix#L15)

install and configure eza as a replacement for ls

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.eza.enableAliases`](programs/eza/default.nix#L23)

Enable shell aliases.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.eza.theme`](programs/eza/default.nix#L17)

the theme to use

**Type:** `lib.types.enum themes.all`

**Default:** `"base16"`

## [`my-dotfiles.fd.enable`](programs/fd/default.nix#L13)

install and configure fd

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fd.ignoreGitRepoFiles`](programs/fd/default.nix#L21)

Ignore files inside .git

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.fd.ignoreMacFiles`](programs/fd/default.nix#L15)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.fish.enable`](programs/fish/default.nix#L16)

install and configure fish

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fish.fixPATH`](programs/fish/default.nix#L19)

fix the PATH variable on login

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.fish.isSHELL`](programs/fish/default.nix#L18)

use as `$SHELL`

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fzf.enable`](programs/fzf/default.nix#L13)

install and configure fzf

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.enable`](programs/git/default.nix#L14)

install and configure git

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.fzf.fixup`](programs/git/default.nix#L20)

Add `git fixup` command

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.git.github`](programs/git/default.nix#L17)

install the gh command-line tool

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.ignoreMacFiles`](programs/git/default.nix#L39)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.git.inPrompt`](programs/git/default.nix#L15)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.useDelta`](programs/git/default.nix#L27)

Use delta to show diffs.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.git.useDyff`](programs/git/default.nix#L33)

Use dyff to show diffs between YAML files.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.global.colorscheme`](programs/globals.nix#L11)


The general color scheme used throughout various programs.


**Type:** `types.enum [ "dark" "light" "auto" ]`

**Default:** `"auto"`

## [`my-dotfiles.global.nerdfonts`](programs/globals.nix#L9)

NerdFonts are supported and installed

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.glow.enable`](programs/glow/default.nix#L15)

install glow

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.glow.theme`](programs/glow/default.nix#L17)

the theme to use

**Type:** `lib.types.enum (themes.all)`

**Default:** `"base16"`

## [`my-dotfiles.goldwarden.enable`](programs/goldwarden/default.nix#L13)

install goldwarden

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.goldwarden.useForSSHAgent`](programs/goldwarden/default.nix#L14)

use goldwarden as the ssh-agent

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.kubesel.enable`](programs/kubesel/default.nix#L15)

install kubesel

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.kubesel.inPrompt`](programs/kubesel/default.nix#L24)

show kubesel info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.kubesel.inPromptClusterOverrides`](programs/kubesel/default.nix#L26)

override the name or color for specific clusters

**Type:** `lib.types.attrs`

**Default:** `{ }`

**Example:**

```nix
{
  "docker-desktop" = {
    name = "docker";
    fg = "#FFFFFF";
    bg = "#1D63ED";
  };
}
```

## [`my-dotfiles.kubesel.kubeconfigs`](programs/kubesel/default.nix#L17)

glob pattern matching kubeconfig files

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `null`

**Example:** `"~/.kube/configs/*.yaml"`

## [`my-dotfiles.neovim.colorschemes.dark`](programs/neovim/default.nix#L23)

The colorscheme used for dark mode.

**Type:** `lib.types.str`

**Default:** `"monokai-pro"`

## [`my-dotfiles.neovim.colorschemes.light`](programs/neovim/default.nix#L29)

The colorscheme used for light mode.

**Type:** `lib.types.str`

**Default:** `"catppuccin-latte"`

## [`my-dotfiles.neovim.enable`](programs/neovim/default.nix#L20)

neovim

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.neovim.integrations.git`](programs/neovim/default.nix#L66)

Enable git integrations.

**Type:** `lib.types.bool`

**Default:** `config.programs.git.enable`

## [`my-dotfiles.neovim.keymap.help`](programs/neovim/default.nix#L54)

Display the keymap after a short delay.

**Type:** `lib.types.nullOr lib.types.bool`

**Default:** `true`

## [`my-dotfiles.neovim.keymap.leader`](programs/neovim/default.nix#L60)

Change the <Leader> key.

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `"<Space>"`

## [`my-dotfiles.neovim.shellAliases.cvim`](programs/neovim/default.nix#L72)

Create cvim alias for using neovim as a pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.shellAliases.yvim`](programs/neovim/default.nix#L78)

Create yvim alias for using neovim as YAML pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.syntax.nix`](programs/neovim/plugins-treesitter.nix#L22)

Enable nix syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.syntax.yaml`](programs/neovim/plugins-treesitter.nix#L16)

Enable yaml syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.ui.focus_dimming`](programs/neovim/default.nix#L42)

Dim unfocused panes.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.neovim.ui.nerdfonts`](programs/neovim/default.nix#L36)

Enable support for using Nerdfonts.

**Type:** `lib.types.bool`

**Default:** `cfgGlobal.nerdfonts`

## [`my-dotfiles.neovim.ui.transparent_background`](programs/neovim/default.nix#L48)

Use a transparent background.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.oh-my-posh.enable`](programs/oh-my-posh/default.nix#L17)

install and configure oh-my-posh

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.oh-my-posh.envAnnotations`](programs/oh-my-posh/default.nix#L25)

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

## [`my-dotfiles.oh-my-posh.extraBlocks`](programs/oh-my-posh/default.nix#L55)

**Type:** `lib.types.attrsOf lib.types.attrs`

**Default:** `{ }`

## [`my-dotfiles.oh-my-posh.newline`](programs/oh-my-posh/default.nix#L19)

user text is entered on a new line

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.oh-my-posh.pathAnnotations`](programs/oh-my-posh/default.nix#L40)

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

## [`my-dotfiles.ranger.enable`](programs/ranger/default.nix#L15)

install and configure ranger

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ranger.glow.forOpen`](programs/ranger/default.nix#L18)

use glow to open markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ranger.glow.forPreview`](programs/ranger/default.nix#L19)

use glow to preview markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ripgrep.enable`](programs/ripgrep/default.nix#L13)

install ripgrep

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.enable`](programs/vscode/default.nix#L20)

install and configure Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.bash.enable`](programs/vscode/language-bash.nix#L16)

add Bash language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.go.compiler.package`](programs/vscode/language-go.nix#L18)

the Go compiler package

**Type:** `any`

**Default:** `pkgs-unstable.go`

## [`my-dotfiles.vscode.language.go.debugger.enable`](programs/vscode/language-go.nix#L24)

install the Go debugger, dlv

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.go.debugger.package`](programs/vscode/language-go.nix#L29)

the dlv package

**Type:** `any`

**Default:** `pkgs-unstable.delve`

## [`my-dotfiles.vscode.language.go.enable`](programs/vscode/language-go.nix#L16)

add Go language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.go.lsp.enable`](programs/vscode/language-go.nix#L36)

install the Go language server, gopls

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.go.lsp.package`](programs/vscode/language-go.nix#L42)

the gopls package

**Type:** `any`

**Default:** `pkgs-unstable.gopls`

## [`my-dotfiles.vscode.language.nix.enable`](programs/vscode/language-nix.nix#L15)

add Nix language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.nix.formatter`](programs/vscode/language-nix.nix#L23)

the formatter to use for Nix files

**Type:** `lib.types.enum [ "nixfmt" ]`

**Default:** `"nixfmt"`

## [`my-dotfiles.vscode.language.nix.lsp.enable`](programs/vscode/language-nix.nix#L17)

use a Language Server for Nix language support

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.yq.enable`](programs/yq/default.nix#L13)

install and configure yq

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.zoxide.enable`](programs/zoxide/default.nix#L13)

install and configure zoxide

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
