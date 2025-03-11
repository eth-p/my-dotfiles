# NixOS Module Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| [`options.my-dotfiles.bat.enable`](programs/bat/default.nix#L13) | `boolean` | `false` | install and configure bat |
| [`options.my-dotfiles.bat.enableBatman`](programs/bat/default.nix#L15) | `lib.types.bool` | `true` | Enable batman for reading manpages. |
| [`options.my-dotfiles.btop.enable`](programs/btop/default.nix#L13) | `boolean` | `false` | install and configure btop |
| [`options.my-dotfiles.carapace.enable`](programs/carapace/default.nix#L13) | `boolean` | `false` | install and configure carapace |
| [`options.my-dotfiles.devenv.enable`](programs/devenv/default.nix#L14) | `boolean` | `false` | install devenv |
| [`options.my-dotfiles.devenv.inPrompt`](programs/devenv/default.nix#L15) | `boolean` | `false` | show git info in the shell prompt |
| [`options.my-dotfiles.direnv.enable`](programs/direnv/default.nix#L13) | `boolean` | `false` | install direnv |
| [`options.my-dotfiles.direnv.hideDiff`](programs/direnv/default.nix#L15) | `boolean` | `false` | hide the environment variable diff |
| [`options.my-dotfiles.eza.enable`](programs/eza/default.nix#L15) | `boolean` | `false` | install and configure eza as a replacement for ls |
| [`options.my-dotfiles.eza.enableAliases`](programs/eza/default.nix#L23) | `lib.types.bool` | `true` | Enable shell aliases. |
| [`options.my-dotfiles.eza.theme`](programs/eza/default.nix#L17) | `enum: [...]` | `"base16"` | the theme to use |
| [`options.my-dotfiles.fd.enable`](programs/fd/default.nix#L13) | `boolean` | `false` | install and configure fd |
| [`options.my-dotfiles.fd.ignoreGitRepoFiles`](programs/fd/default.nix#L21) | `lib.types.bool` | `true` | Ignore files inside .git |
| [`options.my-dotfiles.fd.ignoreMacFiles`](programs/fd/default.nix#L15) | `lib.types.bool` | `pkgs.stdenv.isDarwin` | Ignore system files created by MacOS. |
| [`options.my-dotfiles.fish.enable`](programs/fish/default.nix#L13) | `boolean` | `false` | install and configure fish |
| [`options.my-dotfiles.fish.isSHELL`](programs/fish/default.nix#L15) | `boolean` | `false` | use as `$SHELL` |
| [`options.my-dotfiles.fzf.enable`](programs/fzf/default.nix#L13) | `boolean` | `false` | install and configure fzf |
| [`options.my-dotfiles.git.enable`](programs/git/default.nix#L14) | `boolean` | `false` | install and configure git |
| [`options.my-dotfiles.git.fzf.fixup`](programs/git/default.nix#L20) | `lib.types.bool` | `false` | Add `git fixup` command |
| [`options.my-dotfiles.git.github`](programs/git/default.nix#L17) | `boolean` | `false` | install the gh command-line tool |
| [`options.my-dotfiles.git.ignoreMacFiles`](programs/git/default.nix#L39) | `lib.types.bool` | `pkgs.stdenv.isDarwin` | Ignore system files created by MacOS. |
| [`options.my-dotfiles.git.inPrompt`](programs/git/default.nix#L15) | `boolean` | `false` | show git info in the shell prompt |
| [`options.my-dotfiles.git.useDelta`](programs/git/default.nix#L27) | `lib.types.bool` | `true` | Use delta to show diffs. |
| [`options.my-dotfiles.git.useDyff`](programs/git/default.nix#L33) | `lib.types.bool` | `true` | Use dyff to show diffs between YAML files. |
| [`options.my-dotfiles.glow.enable`](programs/glow/default.nix#L15) | `boolean` | `false` | install glow |
| [`options.my-dotfiles.glow.theme`](programs/glow/default.nix#L17) | `enum: [...]` | `"base16"` | the theme to use |
| [`options.my-dotfiles.neovim.enable`](programs/neovim/default.nix#L15) | `boolean` | `false` | neovim |
| [`options.my-dotfiles.neovim.integrations.git`](programs/neovim/default.nix#L35) | `lib.types.bool` | `config.programs.git.enable` | Enable git integrations. |
| [`options.my-dotfiles.neovim.ui.focus_dimming`](programs/neovim/default.nix#L23) | `lib.types.bool` | `true` | Dim unfocused panes. |
| [`options.my-dotfiles.neovim.ui.nerdfonts`](programs/neovim/default.nix#L17) | `lib.types.bool` | `false` | Enable support for using Nerdfonts. |
| [`options.my-dotfiles.neovim.ui.transparent_background`](programs/neovim/default.nix#L29) | `lib.types.bool` | `false` | Use a transparent background. |
| [`options.my-dotfiles.oh-my-posh.enable`](programs/oh-my-posh/default.nix#L16) | `boolean` | `false` | install and configure oh-my-posh |
| [`options.my-dotfiles.oh-my-posh.envAnnotations`](programs/oh-my-posh/default.nix#L24) | `lib.types.attrsOf lib.types.attrs` | `{ }` | - |
| [`options.my-dotfiles.oh-my-posh.newline`](programs/oh-my-posh/default.nix#L18) | `lib.types.bool` | `true` | user text is entered on a new line |
| [`options.my-dotfiles.oh-my-posh.pathAnnotations`](programs/oh-my-posh/default.nix#L39) | `lib.types.attrsOf lib.types.attrs` | `{ }` | - |
| [`options.my-dotfiles.ranger.enable`](programs/ranger/default.nix#L15) | `boolean` | `false` | install and configure ranger |
| [`options.my-dotfiles.ranger.glow.forOpen`](programs/ranger/default.nix#L18) | `boolean` | `false` | use glow to open markdown files |
| [`options.my-dotfiles.ranger.glow.forPreview`](programs/ranger/default.nix#L19) | `boolean` | `false` | use glow to preview markdown files |
| [`options.my-dotfiles.ripgrep.enable`](programs/ripgrep/default.nix#L13) | `boolean` | `false` | install ripgrep |
| [`options.my-dotfiles.zoxide.enable`](programs/zoxide/default.nix#L13) | `boolean` | `false` | install and configure zoxide |
| [`options.programs.ranger.scope.extension`](programs/ranger/patch-scope-options.nix#L31) | `lib.types.listOf bashCase` | `[ ]` | - |
| [`options.programs.ranger.scope.imageType`](programs/ranger/patch-scope-options.nix#L39) | `lib.types.listOf bashCase` | `[ ]` | - |
| [`options.programs.ranger.scope.mimeType`](programs/ranger/patch-scope-options.nix#L35) | `lib.types.listOf bashCase` | `[ ]` | - |


*Generated with [nix-options-doc](https://github.com/Thunderbottom/nix-options-doc)*
