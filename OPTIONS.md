# NixOS Module Options


## [`my-dotfiles._internal.shell.executable`](modules/internal.nix#L28)


**INTERNAL USE ONLY — DO NOT SET**
The main executable of the default user shell.


**Type:** `lib.types.nullOr lib.types.pathInStore`

**Default:** `lib.getExe cfg.shell.package`

## [`my-dotfiles._internal.shell.package`](modules/internal.nix#L18)


**INTERNAL USE ONLY — DO NOT SET**
The default user shell.


**Type:** `lib.types.nullOr lib.types.package`

## [`my-dotfiles.global.colorscheme`](modules/globals.nix#L48)


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

## [`my-dotfiles.global.font-category.code`](modules/globals.nix#L33)

the monospace font family used for displaying code.

**Type:** `fontType`

**Default:**

```nix
{
  package = pkgs.nerd-fonts.jetbrains-mono;
  family-name = "JetBrainsMonoNL Nerd Font";
}
```

## [`my-dotfiles.global.font-category.terminal`](modules/globals.nix#L41)

the monospace font family used for the terminal.

**Type:** `fontType`

**Default:** `config.my-dotfiles.global.font-category.code`

## [`my-dotfiles.global.nerdfonts`](modules/globals.nix#L30)

NerdFonts are supported and installed

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.bat.enable`](modules/programs/bat/default.nix#L18)

install and configure bat

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.bat.enableBatman`](modules/programs/bat/default.nix#L20)

Enable batman for reading manpages.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.bitwarden.enable`](modules/programs/bitwarden/default.nix#L18)

install Bitwarden

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.bitwarden.useForSSHAgent`](modules/programs/bitwarden/default.nix#L19)

use Bitwarden as the ssh-agent

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.btop.enable`](modules/programs/btop/default.nix#L18)

install and configure btop

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.carapace.enable`](modules/programs/carapace/default.nix#L20)

install and configure carapace

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.carapace.overlays`](modules/programs/carapace/default.nix#L22)


Completion overlays to install in the carapace config directory.


**Type:** `lib.types.attrsOf yamlFormat.type`

**Default:** `{ }`

## [`my-dotfiles.programs.devenv.enable`](modules/programs/devenv/default.nix#L21)

install devenv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.devenv.inPrompt`](modules/programs/devenv/default.nix#L22)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.direnv.enable`](modules/programs/direnv/default.nix#L18)

install direnv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.direnv.hideDiff`](modules/programs/direnv/default.nix#L20)

hide the environment variable diff

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.discord.betterdiscord.enable`](modules/programs/discord/default.nix#L34)

install BetterDiscord

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.discord.enable`](modules/programs/discord/default.nix#L18)

enable Discord config

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.discord.source`](modules/programs/discord/default.nix#L27)

the installation source for Discord

**Type:** `lib.types.enum [ "flatpak" ]`

**Default:** `"flatpak"`

## [`my-dotfiles.programs.discord.supported`](modules/programs/discord/default.nix#L20)

whether Discord is supported on the current platform

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.hostPlatform.isLinux`

## [`my-dotfiles.programs.ets.enable`](modules/programs/ets/default.nix#L18)

install and configure ets

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.eza.enable`](modules/programs/eza/default.nix#L20)

install and configure eza as a replacement for ls

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.eza.enableAliases`](modules/programs/eza/default.nix#L28)

Enable shell aliases.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.eza.theme`](modules/programs/eza/default.nix#L22)

the theme to use

**Type:** `lib.types.enum themes.all`

**Default:** `"base16"`

## [`my-dotfiles.programs.fd.enable`](modules/programs/fd/default.nix#L18)

install and configure fd

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.fd.ignoreGitRepoFiles`](modules/programs/fd/default.nix#L26)

Ignore files inside .git

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.fd.ignoreMacFiles`](modules/programs/fd/default.nix#L20)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.hostPlatform.isDarwin`

## [`my-dotfiles.programs.fish.enable`](modules/programs/fish/default.nix#L23)

install and configure fish

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.fish.fixPATH`](modules/programs/fish/default.nix#L26)

fix the PATH variable on login

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.hostPlatform.isDarwin`

## [`my-dotfiles.programs.fish.isSHELL`](modules/programs/fish/default.nix#L25)

use as `$SHELL`

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.fzf.enable`](modules/programs/fzf/default.nix#L18)

install and configure fzf

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.git.enable`](modules/programs/git/default.nix#L20)

install and configure git

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.git.fzf.fixup`](modules/programs/git/default.nix#L26)

Add `git fixup` command

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.git.github-actions`](modules/programs/git/default.nix#L23)

install the act command-line tool for locally running GitHub Actions

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.git.ignoreMacFiles`](modules/programs/git/default.nix#L45)

Ignore system files created by MacOS.

**Type:** `lib.types.bool`

**Default:** `pkgs.stdenv.hostPlatform.isDarwin`

## [`my-dotfiles.programs.git.inPrompt`](modules/programs/git/default.nix#L21)

show git info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.git.useDelta`](modules/programs/git/default.nix#L33)

Use delta to show diffs.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.git.useDyff`](modules/programs/git/default.nix#L39)

Use dyff to show diffs between YAML files.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.github-act.containerArchitecture`](modules/programs/github-act/default.nix#L35)

the container architecture to use for runners

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"linux/amd64"`

## [`my-dotfiles.programs.github-act.enable`](modules/programs/github-act/default.nix#L20)

install and configure act, the local GitHub Actions runner

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.github-act.extraConfig`](modules/programs/github-act/default.nix#L51)

extra values to add to `.actrc`

**Type:** `lib.types.lines`

**Default:** `""`

## [`my-dotfiles.programs.github-act.githubEnterpriseHostname`](modules/programs/github-act/default.nix#L28)

the hostname of the GitHub Enterprise instance, if using one

**Type:** `lib.types.str`

**Default:** `""`

**Example:** `"github.my-company.com"`

## [`my-dotfiles.programs.github-act.package`](modules/programs/github-act/default.nix#L22)

the act package to install

**Type:** `lib.types.package`

**Default:** `pkgs.act`

## [`my-dotfiles.programs.github-act.runnerImages`](modules/programs/github-act/default.nix#L42)

the available runners (platforms) and their Docker images

**Type:** `lib.types.attrsOf (lib.types.str)`

**Default:** `{ }`

**Example:**

```nix
{
  "ubuntu-18.04" = "nektos/act-environments-ubuntu:18.04";
}
```

## [`my-dotfiles.programs.github-cli.enable`](modules/programs/github-cli/default.nix#L19)

install and configure the github CLI tool

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.github-cli.stack.enable`](modules/programs/github-cli/default.nix#L21)

install the stack extension

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.glow.enable`](modules/programs/glow/default.nix#L21)

install glow

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.glow.theme`](modules/programs/glow/default.nix#L23)

the theme to use

**Type:** `lib.types.enum (themes.all)`

**Default:** `"base16"`

## [`my-dotfiles.programs.kubectl.alias.ls.enable`](modules/programs/kubectl/my-aliases.nix#L19)

alias to list resources by name

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.kubectl.color.enable`](modules/programs/kubectl/default.nix#L70)

use kubecolor for kubectl output

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.color.package`](modules/programs/kubectl/default.nix#L76)

the kubecolor package to install

**Type:** `lib.types.package`

**Default:** `pkgs.kubecolor`

## [`my-dotfiles.programs.kubectl.enable`](modules/programs/kubectl/default.nix#L30)

install kubectl

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.kubectl.extensions.klock.enable`](modules/programs/kubectl/extension-klock.nix#L20)

install kubectl-klock

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.kubectl.extensions.klock.package`](modules/programs/kubectl/extension-klock.nix#L22)

the kubectl-klock package to install

**Type:** `lib.types.package`

**Default:** `pkgs.kubectl-klock`

## [`my-dotfiles.programs.kubectl.extraAliases`](modules/programs/kubectl/default.nix#L53)

extra kubectl aliases to add to the kuberc file

**Type:** `lib.types.attrsOf kuberc.types.aliasOverride`

**Default:** `{ }`

**Example:**

```nix
{
  gety = {
    command = "get";
    options = {
      output = {
        default = "yaml";
      };
    };
  };
}
```

## [`my-dotfiles.programs.kubectl.extraDefaults`](modules/programs/kubectl/default.nix#L38)

extra default option overrides for specific kubectl subcommands

**Type:** `lib.types.attrsOf kuberc.types.commandDefaults`

**Default:** `{ }`

**Example:**

```nix
{
  apply = {
    options = {
      server-side = {
        default = "true";
      };
    };
  };
}
```

## [`my-dotfiles.programs.kubectl.package`](modules/programs/kubectl/default.nix#L32)

the kubectl package to install

**Type:** `lib.types.package`

**Default:** `pkgs.kubectl`

## [`my-dotfiles.programs.kubectl.serverSideApply`](modules/programs/kubectl/my-defaults.nix#L19)

use server-side apply by default

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.k.enable`](modules/programs/kubectl/shell-aliases.nix#L31)

enable the k alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.k.to`](modules/programs/kubectl/shell-aliases.nix#L36)

the command to alias for the k alias

**Type:** `lib.types.str`

**Default:** `"kubectl"`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kd.enable`](modules/programs/kubectl/shell-aliases.nix#L59)

enable the kd alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kd.to`](modules/programs/kubectl/shell-aliases.nix#L64)

the command to alias for the kd alias

**Type:** `lib.types.str`

**Default:** `"kubectl describe"`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kg.enable`](modules/programs/kubectl/shell-aliases.nix#L45)

enable the kg alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kg.to`](modules/programs/kubectl/shell-aliases.nix#L50)

the command to alias for the kg alias

**Type:** `lib.types.str`

**Default:** `"kubectl get"`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kgo.enable`](modules/programs/kubectl/shell-aliases.nix#L73)

enable the kgo alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kgo.to`](modules/programs/kubectl/shell-aliases.nix#L78)

the command to alias for the kgo alias

**Type:** `lib.types.str`

**Default:** `"kubectl get -oyaml"`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.klog.enable`](modules/programs/kubectl/shell-aliases.nix#L87)

enable the klog alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.klog.to`](modules/programs/kubectl/shell-aliases.nix#L92)

the command to alias for the klog alias

**Type:** `lib.types.str`

**Default:** `"kubectl logs"`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kwatch.enable`](modules/programs/kubectl/shell-aliases.nix#L101)

enable the kwatch alias

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubectl.shellAliases.alias.kwatch.to`](modules/programs/kubectl/shell-aliases.nix#L106)

the command to alias for the kwatch alias

**Type:** `lib.types.str`

**Default:** `"kubectl watch"`

## [`my-dotfiles.programs.kubectl.shellAliases.enable`](modules/programs/kubectl/shell-aliases.nix#L24)

add shell aliases and abbreviations for kubectl commands

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubesel.enable`](modules/programs/kubesel/default.nix#L25)

install kubesel

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.kubesel.enableFishAliases`](modules/programs/kubesel/shell-aliases.nix#L24)

add fish shell aliases and abbreviations for kubesel commands

**Type:** `lib.types.bool`

**Default:** `cfg.enableShellAliases`

## [`my-dotfiles.programs.kubesel.enableShellAliases`](modules/programs/kubesel/shell-aliases.nix#L18)

add shell aliases and abbreviations for kubesel commands

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.kubesel.inPrompt`](modules/programs/kubesel/default.nix#L40)

show kubesel info in the shell prompt

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.kubesel.inPromptClusterOverrides`](modules/programs/kubesel/default.nix#L42)

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

## [`my-dotfiles.programs.kubesel.kubeconfigs`](modules/programs/kubesel/default.nix#L33)

glob pattern matching kubeconfig files

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `null`

**Example:** `"~/.kube/configs/*.yaml"`

## [`my-dotfiles.programs.kubesel.package`](modules/programs/kubesel/default.nix#L27)

the kubesel package to install

**Type:** `lib.types.package`

**Default:** `pkgs.kubesel`

## [`my-dotfiles.programs.lf.enable`](modules/programs/lf/default.nix#L20)

install and configure lf

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.neovim.colorschemes.dark`](modules/programs/neovim/default.nix#L32)

The colorscheme used for dark mode.

**Type:** `lib.types.str`

**Default:** `"monokai-pro"`

## [`my-dotfiles.programs.neovim.colorschemes.light`](modules/programs/neovim/default.nix#L38)

The colorscheme used for light mode.

**Type:** `lib.types.str`

**Default:** `"catppuccin-latte"`

## [`my-dotfiles.programs.neovim.editor.rulers`](modules/programs/neovim/default.nix#L99)

Column numbers to draw a ruler at.

**Type:** `lib.types.listOf lib.types.int`

**Default:**

```nix
[
  80
  120
]
```

## [`my-dotfiles.programs.neovim.enable`](modules/programs/neovim/default.nix#L25)

neovim

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.neovim.integrations.git`](modules/programs/neovim/default.nix#L75)

Enable git integrations.

**Type:** `lib.types.bool`

**Default:** `config.programs.git.enable`

## [`my-dotfiles.programs.neovim.integrations.xxd`](modules/programs/neovim/default.nix#L81)

Enable hex editing with xxd.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.neovim.keymap.help`](modules/programs/neovim/default.nix#L63)

Display the keymap after a short delay.

**Type:** `lib.types.nullOr lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.neovim.keymap.leader`](modules/programs/neovim/default.nix#L69)

Change the <Leader> key.

**Type:** `lib.types.nullOr lib.types.str`

**Default:** `"<Space>"`

## [`my-dotfiles.programs.neovim.shellAliases.cvim`](modules/programs/neovim/default.nix#L87)

Create cvim alias for using neovim as a pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.neovim.shellAliases.yvim`](modules/programs/neovim/default.nix#L93)

Create yvim alias for using neovim as YAML pager.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.neovim.syntax.nix`](modules/programs/neovim/plugins-treesitter.nix#L27)

Enable nix syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.neovim.syntax.yaml`](modules/programs/neovim/plugins-treesitter.nix#L21)

Enable yaml syntax support (treesitter).

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.neovim.ui.focus_dimming`](modules/programs/neovim/default.nix#L51)

Dim unfocused panes.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.neovim.ui.nerdfonts`](modules/programs/neovim/default.nix#L45)

Enable support for using Nerdfonts.

**Type:** `lib.types.bool`

**Default:** `cfgGlobal.nerdfonts`

## [`my-dotfiles.programs.neovim.ui.transparent_background`](modules/programs/neovim/default.nix#L57)

Use a transparent background.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.oh-my-posh.enable`](modules/programs/oh-my-posh/default.nix#L43)

install and configure oh-my-posh

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.oh-my-posh.enableFishIntegration`](modules/programs/oh-my-posh/default.nix#L95)

use oh-my-posh on fish

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.oh-my-posh.envAnnotations`](modules/programs/oh-my-posh/default.nix#L60)

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

## [`my-dotfiles.programs.oh-my-posh.extraBlocks`](modules/programs/oh-my-posh/default.nix#L90)

**Type:** `lib.types.attrsOf lib.types.attrs`

**Default:** `{ }`

## [`my-dotfiles.programs.oh-my-posh.newline`](modules/programs/oh-my-posh/default.nix#L45)

user text is entered on a new line

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.oh-my-posh.pathAnnotations`](modules/programs/oh-my-posh/default.nix#L75)

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

## [`my-dotfiles.programs.oh-my-posh.streaming.enable`](modules/programs/oh-my-posh/default.nix#L52)

render slow prompt segments in the background

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.oh-my-posh.streaming.timeout`](modules/programs/oh-my-posh/default.nix#L53)

max time to wait before showing the incomplete prompt

**Type:** `lib.types.int`

**Default:** `100`

## [`my-dotfiles.programs.ranger.enable`](modules/programs/ranger/default.nix#L20)

install and configure ranger

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.ranger.glow.forOpen`](modules/programs/ranger/default.nix#L23)

use glow to open markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.ranger.glow.forPreview`](modules/programs/ranger/default.nix#L24)

use glow to preview markdown files

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.ripgrep.enable`](modules/programs/ripgrep/default.nix#L18)

install ripgrep

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.uv.enable`](modules/programs/uv/default.nix#L21)

install and configure uv

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vicinae.enable`](modules/programs/vicinae/default.nix#L18)

install vicinae

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.bookmarks.enable`](modules/programs/vscode/feature/bookmarks.nix#L23)

add bookmark support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.colorscheme`](modules/programs/vscode/theme.nix#L22)

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

## [`my-dotfiles.programs.vscode.config.allowedLinkSchemes.extras`](modules/programs/vscode/terminal.nix#L27)

Extra hyperlink schemes that are allowed to be opened.

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[ ]`

## [`my-dotfiles.programs.vscode.config.allowedLinkSchemes.includeDefaults`](modules/programs/vscode/terminal.nix#L21)

Include the default hyperlink schemes that are allowed to be opened.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.copilot.enable`](modules/programs/vscode/feature/copilot.nix#L22)

add GitHub Copilot to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.dependencies.packages`](modules/programs/vscode/default.nix#L45)

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

## [`my-dotfiles.programs.vscode.dependencies.unfreePackages`](modules/programs/vscode/default.nix#L57)

Unfree packages to allow.

**Type:** `lib.types.listOf lib.types.str`

**Default:** `[ ]`

**Example:** `[ "vscode-extension-ms-vscode-remote-remote-ssh" ]`

## [`my-dotfiles.programs.vscode.devcontainers.enable`](modules/programs/vscode/feature/devcontainers.nix#L22)

add support for running VS Code in dev containers

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.devenv.enable`](modules/programs/vscode/feature/devenv.nix#L23)

add devenv support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.editor.rulers`](modules/programs/vscode/editor.nix#L26)

Column numbers to draw a ruler at.

**Type:** `lib.types.listOf lib.types.int`

**Default:**

```nix
[
  80
  120
]
```

## [`my-dotfiles.programs.vscode.editor.whitespace.showTrailing`](modules/programs/vscode/editor.nix#L35)

Highlight trailing whitespace.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.enable`](modules/programs/vscode/default.nix#L35)

install and configure Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.fhs.enabled`](modules/programs/vscode/default.nix#L38)

Use a FHS environment for VS Code.

**Type:** `lib.types.bool`

**Default:** `false`

## [`my-dotfiles.programs.vscode.github.enable`](modules/programs/vscode/feature/github.nix#L22)

add GitHub-centric extensions

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.keymap.bind-cw`](modules/programs/vscode/keymap/bind-cw.nix#L22)

Map Ctrl-W to control panes and focus

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.keymap.bindings`](modules/programs/vscode/keymap/default.nix#L38)

custom keybindings

**Type:** `lib.types.listOf vscode.types.keybind`

**Default:** `[ ]`

## [`my-dotfiles.programs.vscode.keymap.help.enable`](modules/programs/vscode/keymap/help.nix#L22)

show a help menu for multi-key key bindings

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.keymap.style`](modules/programs/vscode/keymap/default.nix#L29)

use alternate keybindings

**Type:**

```nix
lib.types.enum [
  "default"
  "intellij"
]
```

**Default:** `"default"`

## [`my-dotfiles.programs.vscode.kubernetes.enable`](modules/programs/vscode/feature/kubernetes.nix#L22)

add Kubernetes-centric extensions

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.bash.enable`](modules/programs/vscode/language/bash/default.nix#L22)

add Bash language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.bash.shellcheck.package`](modules/programs/vscode/language/bash/default.nix#L25)

the shellcheck package

**Type:** `lib.types.package`

**Default:** `pkgs.shellcheck`

## [`my-dotfiles.programs.vscode.language.go.compiler.package`](modules/programs/vscode/language/go/default.nix#L25)

the Go compiler package

**Type:** `any`

**Default:** `pkgs.go`

## [`my-dotfiles.programs.vscode.language.go.debugger.enable`](modules/programs/vscode/language/go/default.nix#L31)

install the Go debugger, dlv

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.go.debugger.package`](modules/programs/vscode/language/go/default.nix#L36)

the dlv package

**Type:** `any`

**Default:** `pkgs.delve`

## [`my-dotfiles.programs.vscode.language.go.enable`](modules/programs/vscode/language/go/default.nix#L23)

add Go language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.go.linter.enable`](modules/programs/vscode/language/go/default.nix#L43)

install golangci-lint for linting Go source code

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.go.linter.package`](modules/programs/vscode/language/go/default.nix#L49)

the golangci-lint package

**Type:** `any`

**Default:** `pkgs.golangci-lint`

## [`my-dotfiles.programs.vscode.language.go.lsp.enable`](modules/programs/vscode/language/go/default.nix#L56)

install the Go language server, gopls

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.go.lsp.package`](modules/programs/vscode/language/go/default.nix#L62)

the gopls package

**Type:** `any`

**Default:** `pkgs.gopls`

## [`my-dotfiles.programs.vscode.language.go.snippets.general`](modules/programs/vscode/language/go/default.nix#L69)

add snippets for general language features

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.makefile.enable`](modules/programs/vscode/language/makefile/default.nix#L22)

add Makefile language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.makefile.showWhitespace`](modules/programs/vscode/language/makefile/default.nix#L24)

Show boundary whitespace in Makefiles.

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.nix.enable`](modules/programs/vscode/language/nix/default.nix#L22)

add Nix language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.nix.formatter`](modules/programs/vscode/language/nix/default.nix#L30)

the formatter to use for Nix files

**Type:** `lib.types.enum [ "nixfmt" ]`

**Default:** `"nixfmt"`

## [`my-dotfiles.programs.vscode.language.nix.lsp.enable`](modules/programs/vscode/language/nix/default.nix#L24)

use a Language Server for Nix language support

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.python.enable`](modules/programs/vscode/language/python/default.nix#L22)

add python language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.rust.enable`](modules/programs/vscode/language/rust/default.nix#L22)

add Rust language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.rust.lsp.enable`](modules/programs/vscode/language/rust/default.nix#L25)

install the Rust language server, rust-analyzer

**Type:** `lib.types.bool`

**Default:** `true`

## [`my-dotfiles.programs.vscode.language.rust.lsp.package`](modules/programs/vscode/language/rust/default.nix#L31)

the rust-analyzer package

**Type:** `any`

**Default:** `pkgs.rust-analyzer`

## [`my-dotfiles.programs.vscode.language.toml.enable`](modules/programs/vscode/language/toml/default.nix#L22)

add TOML language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.language.yaml.enable`](modules/programs/vscode/language/yaml/default.nix#L22)

add Yaml language support to Visual Studio Code

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.onlyConfigure`](modules/programs/vscode/default.nix#L36)

do not install Visual Studio Code, only configure it

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.vscode.todos.enable`](modules/programs/vscode/feature/todos.nix#L22)

improve TODO support

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.yq.enable`](modules/programs/yq/default.nix#L18)

install and configure yq

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

## [`my-dotfiles.programs.zoxide.enable`](modules/programs/zoxide/default.nix#L18)

install and configure zoxide

**Type:** `boolean`

**Default:** `false`

**Example:** `true`

---
*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
