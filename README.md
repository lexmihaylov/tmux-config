# tmux config

This repository contains my tmux configuration. Install it with this one-line command (requires `curl`, `git`, and `tmux`):

```sh
curl -fsSL https://raw.githubusercontent.com/lexmihaylov/tmux-config/main/install.sh | bash
```

The installer writes the configuration to `~/.config/tmux/tmux.conf`, moving any existing config there to a timestamped backup. It also installs [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm) if needed and installs the configured plugins. The configuration provides:

- **Prefix and reload:** `Ctrl-a` is the prefix (`Ctrl-b` is unbound); press `Ctrl-a` then `r` to reload.
- **Windows and panes:** windows and panes are numbered from 1; new windows and splits start in the current pane's directory. Use `Ctrl-a` then `|` or `-` to split, `h/j/k/l` to move between panes, and `H/J/K/L` to resize them. Window navigation, swapping, renaming, and closing have custom bindings.
- **Sessions and layouts:** `Ctrl-a` then `s` opens the session chooser, `w` opens the window chooser, `Tab` returns to the last window, and `z` toggles pane zoom.
- **Copy mode:** vi-style navigation and selection, with `v` to start a selection and `y` to copy it.
- **Terminal and history:** mouse support, true color, focus events, a 50,000-line scrollback buffer, and a short Escape delay for Neovim.
- **Status bar:** a Catppuccin-inspired dark palette with session, window, date, and time information.
- **Plugins:** TPM, tmux-resurrect, and tmux-continuum for saving and restoring sessions; automatic saves run every 15 minutes and restore is enabled.
