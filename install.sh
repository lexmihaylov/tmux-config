#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_config="$repo_dir/tmux.conf"
target_config="${HOME:?HOME must be set}/.config/tmux/tmux.conf"

if [ ! -f "$source_config" ]; then
  printf 'Config not found: %s\n' "$source_config" >&2
  exit 1
fi

for command in git tmux; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Required command not found: %s (install it first)\n' "$command" >&2
    exit 1
  fi
done

if [ -L "$target_config" ] && [ "$(readlink "$target_config")" = "$source_config" ]; then
  printf 'Already linked: %s -> %s\n' "$target_config" "$source_config"
  exit 0
fi

if [ -e "$target_config" ] || [ -L "$target_config" ]; then
  backup="$target_config.backup.$(date +%Y%m%d%H%M%S)"
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    printf 'Backup path already exists: %s\n' "$backup" >&2
    exit 1
  fi
  mv -- "$target_config" "$backup"
  printf 'Backed up existing config to %s\n' "$backup"
fi

mkdir -p "$(dirname -- "$target_config")"
ln -s -- "$source_config" "$target_config"
printf 'Linked %s -> %s\n' "$target_config" "$source_config"

plugin_dir="$HOME/.tmux/plugins/tpm"
if [ ! -d "$plugin_dir" ]; then
  mkdir -p "$(dirname -- "$plugin_dir")"
  git clone https://github.com/tmux-plugins/tpm "$plugin_dir"
else
  printf 'TPM already installed at %s\n' "$plugin_dir"
fi

tmux start-server
tmux source-file "$target_config"
"$plugin_dir/bin/install_plugins"
printf 'Configuration and plugins installed. Reload tmux with: tmux source-file ~/.config/tmux/tmux.conf\n'
