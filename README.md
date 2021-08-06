# my-dotfiles

A collection of dotfiles that I use to configure my terminal programs.

![A screenshot of vim, cmatrix, and fish inside tmux.](SCREENSHOT.png)

## Requirements

My setup is designed around using [tmux](https://github.com/tmux/tmux/wiki) and [fish](https://fishshell.com/) inside of the [alacritty](https://github.com/alacritty/alacritty) terminal emulator. It might work in other environments, but I'm not going to make any guarantees or promises.

- [fisher](https://github.com/jorgebucaran/fisher) to install fish plugins.
- [vivid](https://github.com/sharkdp/vivid) for colors in `ls`.
- [vim-plug](https://github.com/junegunn/vim-plug) to install vim/nvim plugins.
- [gitmux](https://github.com/arl/gitmux) for git info in the tmux status bar.
- [ranger](https://github.com/ranger/ranger) for file browsing in the terminal.
- `JetBrains Mono NL` font.



## Features

- Alacritty keybinds similar to iTerm2.
- Advanced tmux integrations.
  - Shell variables copied to new split panes or tmux windows.
  - Special integrations for various command line programs.
  - Program-specific context menu with <kbd>Ctrl+X</kbd>.
  - Control-click to open links.
- Built to work with fish shell.
  - Simple, fast, and informative prompt using prompt using [promptfessional](https://github.com/eth-p/fish-promptfessional).
  - Quickly change `fish`'s working directory to a `ranger` bookmark with <kbd>Ctrl+Q</kbd>.
- Monokai theme.



## Installation

**Mac**  
Homebrew and [some makefiles](.install/) provide an easy way to install everything.

```console
$ make requirements
$ make install
```




## Configurations

Environment

- [alacritty](#alacritty)
- [fish](#fish)
- [tmux](#tmux)

Tools

- [bat](#bat)
- [nvim](#nvim)
- [ranger](#ranger)



---

### alacritty

**Install**  

1. Copy the alacritty config files.
2. Install [BetterTouchTool](https://folivora.ai/).
3. Install the BetterTouchTool [Alacritty preset](extra/BetterTouchTool).  
   *This allows <kbd>Cmd+&grave;</kbd> to work correctly.*

No special instructions, just copy the files.

**Bindings**  

|Key|Action|
|:--|:--|
|<kbd>Cmd+K</kbd>|Clears the current `tmux` pane.|
|<kbd>Cmd+N</kbd>/<kbd>Cmd+T</kbd>|Creates a new `tmux` window.|
|<kbd>Cmd+W</kbd>|Closes the current `tmux` pane, prompting if necessary.|
|<kbd>Cmd+D</kbd>|Creates a new vertical split in `tmux`.|
|<kbd>Cmd+Shift+D</kbd>|Creates a new horizontal split in `tmux`.|
|<kbd>Cmd+[1-9]</kbd>|Switches the the `tmux` window.|
|<kbd>Cmd+&grave;</kbd>/<kbd>Cmd+Shift+&grave;</kbd>|Switches between the next and previous `tmux` window.|
|<kbd>Cmd+C</kbd>|Enters `tmux` copy mode.<br />*When in `vim`, this will copy visual mode highlighted text.*|
|<kbd>Cmd+S</kbd>|Tells `tmux` to try to save the file in the active panel.|
|<kbd>Cmd+O</kbd>|Open a new directory in `fish`, using `ranger` as a file chooser.|

**Customizations.**  

- If running `vim`, <kbd>Cmd+W</kbd> will attempt to close the `vim` buffer instead of the `tmux` pane.
   You can disable this setting in `.local/libexec/tmux-close-pane`.

---

### bat

**Install**  
No special instructions, just copy the files.

---

### fish

**Install**  
1. Install [fisher](https://github.com/jorgebucaran/fisher).
2. Install [vivid](https://github.com/sharkdp/vivid).
3. Copy the files.
4. `fisher`

**Features**

- `kubectx`/`kubens` using [fish-kubeswitch](https://github.com/eth-p/fish-kubeswitch).

**Bindings**  
|Key|Action|
|:--|---|
|<kbd>Ctrl+S</kbd>|Toggle `sudo`.|
|<kbd>Ctrl+Q</kbd>|Navigate to a `ranger` bookmark.|

---

### ranger

**Install**  
No special instructions, just copy the files.

---

### nvim

**Install**  
1. Install [vim-plug](https://github.com/junegunn/vim-plug).
2. Copy the files.
3. Open vim and run `:PlugInstall`.

**Bindings**  
|Mode|Key|Action|
|:--|:--|---|
|Insert|<kbd>Shift+Tab</kbd>|Un-indent.|
|Normal|<kbd>g</kbd><kbd>Left</kbd>/<kbd>Shift+Up</kbd>|Previous git change.|
|Normal|<kbd>g</kbd><kbd>Right</kbd>/<kbd>Shift+Down</kbd>|Next git change.|
|Normal|<kbd>h</kbd>|Toggle git change line highlighting.|
|Any, Multiple Buffers|<kbd>F1</kbd>|Previous buffer.|
|Any, Multiple Buffers|<kbd>F2</kbd>|Next buffer.|
|Any, Single Buffer|<kbd>F1</kbd>|Previous git conflict.|
|Any, Single Buffer|<kbd>F2</kbd>|Next git conflict.|
|Visual|<kbd>F5</kbd>|Copy the highlighted text to the system clipboard.|
|Any|<kbd>F6</kbd>|Save the current buffer.|
|Any|<kbd>F8</kbd>|Undo the last change.|
|Any|<kbd>F9</kbd>|Redo the last change.|

**Integrations** (using [eth-p/vim-tmux](https://github.com/eth-p/vim-tmux))  

- Command: `Wcmd [shell command...]`
  Run a shell command on save.  
  
  Runs `[shell command...]` in the tmux pane that was marked when `Wcmd` was called.


---

### tmux

**Install**  

1. Copy the tmux config files.
2. Copy the `.local/libexe/tmux-*` files to `$HOME/.local/libexec/`.
3. Install [gitmux](https://github.com/arl/gitmux).

**Bindings**  
|Key|Action|
|:--|:--|
|<kbd>Ctrl+A</kbd>|Prefix key.|
|<kbd>Ctrl+A</kbd><kbd>\|</kbd>|Create a vertical split.|
|<kbd>Ctrl+A</kbd><kbd>\-</kbd>|Create a horizontal split.|
|<kbd>Ctrl+A</kbd><kbd>K</kbd>|Clear the current pane. \* \*\*|
|<kbd>Ctrl+A</kbd><kbd>X</kbd>|Close the current pane. \*|
|<kbd>Ctrl+A</kbd><kbd>R</kbd>|Reload the tmux config.|
|<kbd>Ctrl+A</kbd><kbd>F6</kbd>|Attempt to save the vim buffer in the current pane. \*|
|<kbd>Ctrl+X</kbd>|Open the pane context menu. \*|
|<kbd>Alt+Left</kbd>|Select the pane to the left of the current pane.|
|<kbd>Alt+Right</kbd>|Select the pane to the right of the current pane.|
|<kbd>Alt+Up</kbd>|Select the pane above the current pane.|
|<kbd>Alt+Down</kbd>|Select the pane below the current pane.|
|<kbd>Alt+Shift+Left</kbd>|Select the previous window.|
|<kbd>Alt+Shift+Right</kbd>|Select the next window.|

\* Requires help from one of the `tmux-` bash scripts.  
\*\* Requires `10-ethp-integrations.fish`.  

**Copy Mode Bindings**
|Key|Action|
|:--|:--|
|<kbd>V</kbd>|Toggle selection.|
|<kbd>Shift+V</kbd>|Toggle line selection.|
|<kbd>Y</kbd>|Save selection to system clipboard.|
|<kbd>Ctrl+C</kbd>/<kbd>Escape</kbd>|Cancel copy mode.|

**Context Menu**  
With <kbd>Ctrl+X</kbd>, a context menu is displayed for the currently active pane.
This has additional menu items for:

- `vim`
- `fish`
- `ranger`

