# tmux config

This repository contains my tmux configuration. On each device, clone the repository and run the installer:

```sh
git clone <your-github-repository-url> ~/tmux-config
cd ~/tmux-config
./install.sh
```

The installer requires `git` and `tmux`. It symlinks the repository's `tmux.conf` to `~/.config/tmux/tmux.conf` (moving any existing config there to a timestamped backup), installs [Tmux Plugin Manager (TPM)](https://github.com/tmux-plugins/tpm) if needed, and installs the configured plugins. To sync config changes later, run `git pull` from the cloned repository; the symlink makes the updated config active. The config's prefix is `Ctrl-a`.
