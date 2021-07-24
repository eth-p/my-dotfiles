# my-dotfiles

A collection of dotfiles that I use to configure my terminal programs.

![A screenshot of vim, cmatrix, and fish inside tmux.](SCREENSHOT.png)

## Requirements

My configuration is designed around using [tmux](https://github.com/tmux/tmux/wiki) and [fish](https://fishshell.com/) inside of the [alacritty](https://github.com/alacritty/alacritty) terminal emulator. It might work with other configurations, but I'm not going to make any guarantees or promises.

- [fisher](https://github.com/jorgebucaran/fisher) to install fish plugins.
- [vim-plug](https://github.com/junegunn/vim-plug) to install vim/nvim plugins.
- `JetBrains Mono NL` font.



## Features

- Alacritty keybinds similar to iTerm2.
- Useful tmux integrations.
- Fish shell prompt using [promptfessional](https://github.com/eth-p/fish-promptfessional).
- Monokai theme.



## Configurations

Environment

- [alacritty](#alacritty)
- [fish](#fish)
- [tmux](#tmux)

Tools

- [bat](#bat)
- [nvim](#nvim)



---

### alacritty

**Install**  
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
|<kbd>Cmd+`</kbd>/<kbd>Cmd+Shift+`</kbd>|Switches between the next and previous `tmux` window.|

---

### bat

**Install**  
No special instructions, just copy the files.

---

### fish

**Install**  
1. Install [fisher](https://github.com/jorgebucaran/fisher).
2. Copy the files.
3. `fisher`

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

---

### tmux

**Install**  

1. Copy the tmux config files.
2. Copy the `.local/libexe/tmux-*` files to `$HOME/.local/libexec/`.

**Bindings**  
|Key|Action|
|:--|:--|
|<kbd>Ctrl+A</kbd>|Prefix key.|
|<kbd>Ctrl+A</kbd><kbd>\|</kbd>|Create a vertical split.|
|<kbd>Ctrl+A</kbd><kbd>\-</kbd>|Create a horizontal split.|
|<kbd>Ctrl+A</kbd><kbd>K</kbd>|Clear the current pane.<br />*This requires help from a fish keybinding.*|
|<kbd>Ctrl+A</kbd><kbd>X</kbd>|Close the current pane.<br />*This requires help from a bash script.*|
|<kbd>Ctrl+A</kbd><kbd>R</kbd>|Reload the tmux config.|
|<kbd>Alt+Left</kbd>|Select the pane to the left of the current pane.|
|<kbd>Alt+Right</kbd>|Select the pane to the right of the current pane.|
|<kbd>Alt+Up</kbd>|Select the pane above the current pane.|
|<kbd>Alt+Down</kbd>|Select the pane below the current pane.|
|<kbd>Alt+Shift+Left</kbd>|Select the previous window.|
|<kbd>Alt+Shift+Right</kbd>|Select the next window.|