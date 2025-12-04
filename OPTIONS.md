# NixOS Module Options


## [`my-dotfiles.bat.enable`](programs/bat/default.nix#L18)

install and configure bat

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.bat.enableBatman`](programs/bat/default.nix#L20)

Enable batman for reading manpages.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.bitwarden.enable`](programs/bitwarden/default.nix#L18)

install Bitwarden

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.bitwarden.useForSSHAgent`](programs/bitwarden/default.nix#L19)

use Bitwarden as the ssh-agent

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.btop.enable`](programs/btop/default.nix#L18)

install and configure btop

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.carapace.enable`](programs/carapace/default.nix#L18)

install and configure carapace

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.devenv.enable`](programs/devenv/default.nix#L21)

install devenv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.devenv.inPrompt`](programs/devenv/default.nix#L22)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.direnv.enable`](programs/direnv/default.nix#L18)

install direnv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.direnv.hideDiff`](programs/direnv/default.nix#L20)

hide the environment variable diff

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.betterdiscord.enable`](programs/discord/default.nix#L34)

install BetterDiscord

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.enable`](programs/discord/default.nix#L18)

enable Discord config

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.discord.source`](programs/discord/default.nix#L27)

the installation source for Discord

**Type:** `lib.types.enum [ "flatpak" ]`

**Default:** `"flatpak"`

## [`my-dotfiles.discord.supported`](programs/discord/default.nix#L20)

whether Discord is supported on the current platform

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isLinux`

## [`my-dotfiles.ets.enable`](programs/ets/default.nix#L18)

install and configure ets

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.eza.enable`](programs/eza/default.nix#L20)

install and configure eza as a replacement for ls

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.eza.enableAliases`](programs/eza/default.nix#L28)

Enable shell aliases.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.eza.theme`](programs/eza/default.nix#L22)

the theme to use

**Type:** `lib.types.enum themes.all`

**Default:** `"base16"`

## [`my-dotfiles.fd.enable`](programs/fd/default.nix#L18)

install and configure fd

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fd.ignoreGitRepoFiles`](programs/fd/default.nix#L26)

Ignore files inside .git

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.fd.ignoreMacFiles`](programs/fd/default.nix#L20)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.fish.enable`](programs/fish/default.nix#L23)

install and configure fish

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fish.fixPATH`](programs/fish/default.nix#L26)

fix the PATH variable on login

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.fish.isSHELL`](programs/fish/default.nix#L25)

use as `$SHELL`

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.fzf.enable`](programs/fzf/default.nix#L18)

install and configure fzf

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.enable`](programs/git/default.nix#L20)

install and configure git

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.fzf.fixup`](programs/git/default.nix#L26)

Add `git fixup` command

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.git.github-actions`](programs/git/default.nix#L23)

install the act command-line tool for locally running GitHub Actions

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.ignoreMacFiles`](programs/git/default.nix#L45)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.isDarwin`

## [`my-dotfiles.git.inPrompt`](programs/git/default.nix#L21)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.git.useDelta`](programs/git/default.nix#L33)

Use delta to show diffs.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.git.useDyff`](programs/git/default.nix#L39)

Use dyff to show diffs between YAML files.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.github-act.containerArchitecture`](programs/github-act/default.nix#L35)

the container architecture to use for runners

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"linux/amd64"`

## [`my-dotfiles.github-act.enable`](programs/github-act/default.nix#L20)

install and configure act, the local GitHub Actions runner

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.github-act.extraConfig`](programs/github-act/default.nix#L51)

extra values to add to `.actrc`

**Type:** `lib.types.lines`

**Default:** `""`

## [`my-dotfiles.github-act.githubEnterpriseHostname`](programs/github-act/default.nix#L28)

the hostname of the GitHub Enterprise instance, if using one

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"github.my-company.com"`

## [`my-dotfiles.github-act.package`](programs/github-act/default.nix#L22)

the act package to install

**Type:** `lib.types.package`

**Default:** `pkgs.act`

## [`my-dotfiles.github-act.runnerImages`](programs/github-act/default.nix#L42)

the available runners (platforms) and their Docker images

**Type:** `lib.types.attrsOf (lib.types.str)`

**Default:** `{ }`

**Example:**

```nix
{
  "ubuntu-18.04" = "nektos/act-environments-ubuntu:18.04";
}
```

## [`my-dotfiles.github-cli.enable`](programs/github-cli/default.nix#L19)

install and configure the github CLI tool

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.global.colorscheme`](programs/globals.nix#L49)


The general color scheme used throughout various programs.


**Type:**

```nix
types.enum [
  "dark"
  "light"
  "auto"
]
```

**Default:** `"auto"`

## [`my-dotfiles.global.font-category.code`](programs/globals.nix#L34)

the monospace font family used for displaying code.

**Type:** `fontType`

**Default:**

```nix
{
  package = pkgs.nerd-fonts.jetbrains-mono;
  family-name = "JetBrainsMonoNL Nerd Font";
}
```

## [`my-dotfiles.global.font-category.terminal`](programs/globals.nix#L42)

the monospace font family used for the terminal.

**Type:** `fontType`

**Default:** `config.my-dotfiles.global.font-category.code`

## [`my-dotfiles.global.nerdfonts`](programs/globals.nix#L31)

NerdFonts are supported and installed

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.glow.enable`](programs/glow/default.nix#L21)

install glow

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.glow.theme`](programs/glow/default.nix#L23)

the theme to use

**Type:** `lib.types.enum (themes.all)`

**Default:** `"base16"`

## [`my-dotfiles.kubesel.enable`](programs/kubesel/default.nix#L21)

install kubesel

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.kubesel.inPrompt`](programs/kubesel/default.nix#L30)

show kubesel info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.kubesel.inPromptClusterOverrides`](programs/kubesel/default.nix#L32)

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

## [`my-dotfiles.kubesel.kubeconfigs`](programs/kubesel/default.nix#L23)

glob pattern matching kubeconfig files

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `null`

**Example:** `"~/.kube/configs/*.yaml"`

## [`my-dotfiles.neovim.colorschemes.dark`](programs/neovim/default.nix#L33)

The colorscheme used for dark mode.

**Type:** `lib.types.str`

**Default:** `"monokai-pro"`

## [`my-dotfiles.neovim.colorschemes.light`](programs/neovim/default.nix#L39)

The colorscheme used for light mode.

**Type:** `lib.types.str`

**Default:** `"catppuccin-latte"`

## [`my-dotfiles.neovim.editor.rulers`](programs/neovim/default.nix#L100)

Column numbers to draw a ruler at.

**Type:** `lib.types.listOf lib.types.int`

**Default:**

```nix
[
  80
  120
]
```

## [`my-dotfiles.neovim.enable`](programs/neovim/default.nix#L26)

neovim

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.neovim.integrations.git`](programs/neovim/default.nix#L76)

Enable git integrations.

**Type:** `lib.types.bool`

**Default:** `config.programs.git.enable`

## [`my-dotfiles.neovim.integrations.xxd`](programs/neovim/default.nix#L82)

Enable hex editing with xxd.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.keymap.help`](programs/neovim/default.nix#L64)

Display the keymap after a short delay.

**Type:** `lib.types.nullOr lib.types.bool`

**Default:** `true`

## [`my-dotfiles.neovim.keymap.leader`](programs/neovim/default.nix#L70)

Change the <Leader> key.

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `"<Space>"`

## [`my-dotfiles.neovim.shellAliases.cvim`](programs/neovim/default.nix#L88)

Create cvim alias for using neovim as a pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.shellAliases.yvim`](programs/neovim/default.nix#L94)

Create yvim alias for using neovim as YAML pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.syntax.nix`](programs/neovim/plugins-treesitter.nix#L28)

Enable nix syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.syntax.yaml`](programs/neovim/plugins-treesitter.nix#L22)

Enable yaml syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.neovim.ui.focus_dimming`](programs/neovim/default.nix#L52)

Dim unfocused panes.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.neovim.ui.nerdfonts`](programs/neovim/default.nix#L46)

Enable support for using Nerdfonts.

**Type:** `lib.types.bool`

**Default:** `cfgGlobal.nerdfonts`

## [`my-dotfiles.neovim.ui.transparent_background`](programs/neovim/default.nix#L58)

Use a transparent background.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.oh-my-posh.enable`](programs/oh-my-posh/default.nix#L23)

install and configure oh-my-posh

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.oh-my-posh.envAnnotations`](programs/oh-my-posh/default.nix#L31)

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

## [`my-dotfiles.oh-my-posh.extraBlocks`](programs/oh-my-posh/default.nix#L61)

**Type:** `lib.types.attrsOf lib.types.attrs`

**Default:** `{ }`

## [`my-dotfiles.oh-my-posh.newline`](programs/oh-my-posh/default.nix#L25)

user text is entered on a new line

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.oh-my-posh.pathAnnotations`](programs/oh-my-posh/default.nix#L46)

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

## [`my-dotfiles.ranger.enable`](programs/ranger/default.nix#L20)

install and configure ranger

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ranger.glow.forOpen`](programs/ranger/default.nix#L23)

use glow to open markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ranger.glow.forPreview`](programs/ranger/default.nix#L24)

use glow to preview markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.ripgrep.enable`](programs/ripgrep/default.nix#L18)

install ripgrep

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vicinae.enable`](programs/vicinae/default.nix#L18)

install vicinae

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.colorscheme`](programs/vscode/default.nix#L62)

The color scheme used for Visual Studio Code.

**Type:**

```nix
lib.types.enum [
  "dark"
  "light"
  "auto"
]
```

**Default:** `config.my-dotfiles.global.colorscheme`

## [`my-dotfiles.vscode.dependencies.packages`](programs/vscode/default.nix#L135)

Extra packages to install.

**Type:** `my-dotfiles.lib.types.functionListTo lib.types.package`

**Default:** `(pkgs: [ ])`

**Example:**

```nix
(
  pkgs: with pkgs; [
    gcc
    rustc
  ]
)
```

## [`my-dotfiles.vscode.dependencies.unfreePackages`](programs/vscode/default.nix#L147)

Unfree packages to allow.

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[ ]`

**Example:** `[ "vscode-extension-ms-vscode-remote-remote-ssh" ]`

## [`my-dotfiles.vscode.editor.inlineBlame`](programs/vscode/default.nix#L116)

show the git blame as an inline hint

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.editor.rulers`](programs/vscode/default.nix#L108)

Column numbers to draw a ruler at.

**Type:** `lib.types.listOf lib.types.int`

**Default:**

```nix
[
  80
  120
]
```

## [`my-dotfiles.vscode.editor.whitespace.showTrailing`](programs/vscode/default.nix#L121)

Highlight trailing whitespace.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.enable`](programs/vscode/default.nix#L42)

install and configure Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.fhs.enabled`](programs/vscode/default.nix#L128)

Use a FHS environment for VS Code.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.vscode.keybindings.map-cg`](programs/vscode/default.nix#L59)

Map Ctrl-G to goto panes

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.keybindings.map-cw`](programs/vscode/default.nix#L58)

Map Ctrl-W to control panes and focus

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.keybindings.style`](programs/vscode/default.nix#L49)

use alternate keybindings

**Type:**

```nix
lib.types.enum [
  "default"
  "intellij"
]
```

**Default:** `"default"`

## [`my-dotfiles.vscode.language.bash.enable`](programs/vscode/language-bash.nix#L19)

add Bash language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.bash.shellcheck.package`](programs/vscode/language-bash.nix#L22)

the shellcheck package

**Type:** `lib.types.package`

**Default:** `pkgs.shellcheck`

## [`my-dotfiles.vscode.language.go.compiler.package`](programs/vscode/language-go/default.nix#L22)

the Go compiler package

**Type:** `any`

**Default:** `pkgs.go`

## [`my-dotfiles.vscode.language.go.debugger.enable`](programs/vscode/language-go/default.nix#L28)

install the Go debugger, dlv

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.go.debugger.package`](programs/vscode/language-go/default.nix#L33)

the dlv package

**Type:** `any`

**Default:** `pkgs.delve`

## [`my-dotfiles.vscode.language.go.enable`](programs/vscode/language-go/default.nix#L20)

add Go language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.go.linter.enable`](programs/vscode/language-go/default.nix#L40)

install golangci-lint for linting Go source code

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.go.linter.package`](programs/vscode/language-go/default.nix#L46)

the golangci-lint package

**Type:** `any`

**Default:** `pkgs.golangci-lint`

## [`my-dotfiles.vscode.language.go.lsp.enable`](programs/vscode/language-go/default.nix#L53)

install the Go language server, gopls

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.go.lsp.package`](programs/vscode/language-go/default.nix#L59)

the gopls package

**Type:** `any`

**Default:** `pkgs.gopls`

## [`my-dotfiles.vscode.language.go.snippets.general`](programs/vscode/language-go/default.nix#L66)

add snippets for general language features

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.makefile.enable`](programs/vscode/language-makefile.nix#L19)

add Makefile language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.makefile.showWhitespace`](programs/vscode/language-makefile.nix#L21)

Show boundary whitespace in Makefiles.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.nix.enable`](programs/vscode/language-nix.nix#L19)

add Nix language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.nix.formatter`](programs/vscode/language-nix.nix#L27)

the formatter to use for Nix files

**Type:** `lib.types.enum [ "nixfmt" ]`

**Default:** `"nixfmt"`

## [`my-dotfiles.vscode.language.nix.lsp.enable`](programs/vscode/language-nix.nix#L21)

use a Language Server for Nix language support

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.python.enable`](programs/vscode/language-python.nix#L19)

add python language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.rust.enable`](programs/vscode/language-rust.nix#L19)

add Rust language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.rust.lsp.enable`](programs/vscode/language-rust.nix#L22)

install the Rust language server, rust-analyzer

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.vscode.language.rust.lsp.package`](programs/vscode/language-rust.nix#L28)

the rust-analyzer package

**Type:** `any`

**Default:** `pkgs.rust-analyzer`

## [`my-dotfiles.vscode.language.toml.enable`](programs/vscode/language-toml.nix#L19)

add TOML language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.language.yaml.enable`](programs/vscode/language-yaml.nix#L19)

add Yaml language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.onlyConfigure`](programs/vscode/default.nix#L43)

do not install Visual Studio Code, only configure it

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.qol.bookmarks.enable`](programs/vscode/qol-bookmarks.nix#L20)

add bookmarking support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.qol.github.enable`](programs/vscode/qol-github.nix#L19)

add GitHub-centric extensions

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.qol.todo.enable`](programs/vscode/qol-todo.nix#L20)

improve TODO support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.vscode.remote.devcontainer.enable`](programs/vscode/remote-devcontainer.nix#L19)

add support for running VS Code in dev containers

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.yq.enable`](programs/yq/default.nix#L18)

install and configure yq

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.zoxide.enable`](programs/zoxide/default.nix#L18)

install and configure zoxide

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
