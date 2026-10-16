#!/bin/sh
set -eu

config_dir="${HOME:?HOME must be set}/.config/tmux"
target_config="$config_dir/tmux.conf"

for command in git tmux; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Required command not found: %s (install it first)\n' "$command" >&2
    exit 1
  fi
done

if [ -e "$target_config" ] || [ -L "$target_config" ]; then
  backup="$target_config.backup.$(date +%Y%m%d%H%M%S)"
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    printf 'Backup path already exists: %s\n' "$backup" >&2
    exit 1
  fi
  mv -- "$target_config" "$backup"
  printf 'Backed up existing config to %s\n' "$backup"
fi

mkdir -p "$config_dir"
cat > "$target_config" <<'TMUX_CONFIG'
# ============================================================
# TMUX CONFIGURATION
# ============================================================

# ------------------------------------------------------------
# 1. PREFIX
# ------------------------------------------------------------

unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Reload configuration: Prefix + r
bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"


# ------------------------------------------------------------
# 2. GENERAL SETTINGS
# ------------------------------------------------------------

# Enable mouse support
set -g mouse on

# Start window and pane numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Automatically renumber windows after closing one
set -g renumber-windows on

# Increase scrollback history
set -g history-limit 50000

# Reduce Escape delay (important for Neovim)
set -sg escape-time 10

# Enable true color
set -g default-terminal "tmux-256color"
set -as terminal-features ',xterm-256color:RGB'

# Enable focus events for Neovim
set -g focus-events on

# Allow applications to set terminal titles
set -g set-titles on
set -g set-titles-string '#S | #W'

# Increase status refresh frequency
set -g status-interval 5

# Keep windows from automatically renaming themselves
set -g allow-rename off

# Automatically name windows based on running commands
set -g automatic-rename on


# ------------------------------------------------------------
# 3. WINDOW MANAGEMENT
# ------------------------------------------------------------

# Create new window in current working directory
bind c new-window -c "#{pane_current_path}"

# Switch between windows
bind -r n next-window
bind -r p previous-window

# Switch to last active window
bind Tab last-window

# Move current window left/right
bind -r < swap-window -t -1 \; select-window -t -1
bind -r > swap-window -t +1 \; select-window -t +1

# Rename current window: Prefix + ,
bind , command-prompt -I "#W" "rename-window '%%'"

# Kill current window: Prefix + &
bind & confirm-before -p "Kill window #W? (y/n)" kill-window


# ------------------------------------------------------------
# 4. PANE SPLITTING
# ------------------------------------------------------------

# Remove default split bindings
unbind %
unbind '"'

# Split horizontally (left/right): Prefix + |
bind | split-window -h -c "#{pane_current_path}"

# Split vertically (top/bottom): Prefix + -
bind - split-window -v -c "#{pane_current_path}"


# ------------------------------------------------------------
# 5. PANE NAVIGATION
# ------------------------------------------------------------

# Vim-style pane navigation
# Prefix + h/j/k/l

bind -r h select-pane -L
bind -r j select-pane -D
bind -r k select-pane -U
bind -r l select-pane -R

# Cycle through panes
bind -r o select-pane -t :.+

# Switch to previously active pane
bind Space last-pane

# Display pane numbers
bind q display-panes


# ------------------------------------------------------------
# 6. PANE RESIZING
# ------------------------------------------------------------

# Prefix + Shift + H/J/K/L
# Repeatable while holding the key

bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5


# ------------------------------------------------------------
# 7. PANE ACTIONS
# ------------------------------------------------------------

# Zoom/unzoom pane: Prefix + z
bind z resize-pane -Z

# Kill pane: Prefix + x
bind x confirm-before -p "Kill pane? (y/n)" kill-pane

# Break pane into its own window: Prefix + !
bind ! break-pane

# Cycle through pane layouts
bind = next-layout


# ------------------------------------------------------------
# 8. COPY MODE (VIM)
# ------------------------------------------------------------

setw -g mode-keys vi

# Enter copy mode: Prefix + [
bind [ copy-mode

# Start visual selection with v
bind -T copy-mode-vi v send-keys -X begin-selection

# Select entire line with V
bind -T copy-mode-vi V send-keys -X select-line

# Copy selection with y
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Rectangle selection with Ctrl+v
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

# Paste tmux buffer: Prefix + ]
bind ] paste-buffer


# ------------------------------------------------------------
# 9. SESSION MANAGEMENT
# ------------------------------------------------------------

# Session chooser: Prefix + s
bind s choose-tree -Zs

# Window chooser: Prefix + w
bind w choose-tree -Zw

# Rename session: Prefix + $
bind '$' command-prompt -I '#S' "rename-session '%%'"

# Detach session: Prefix + d
bind d detach-client


# ------------------------------------------------------------
# 10. STATUS BAR
# ------------------------------------------------------------

# Catppuccin-inspired colors
# Background: #1e1e2e
# Foreground: #cdd6f4
# Blue:       #89b4fa
# Green:      #a6e3a1
# Gray:       #6c7086

set -g status on
set -g status-position bottom
set -g status-justify left

set -g status-style "bg=#1e1e2e,fg=#cdd6f4"

# Status bar left: session name
set -g status-left-length 40
set -g status-left "#[fg=#1e1e2e,bg=#89b4fa,bold] #S #[default] "

# Status bar right: date and time
set -g status-right-length 80
set -g status-right "#[fg=#6c7086] %Y-%m-%d #[fg=#89b4fa,bold] %H:%M "

# Inactive windows
set -g window-status-format "#[fg=#6c7086] #I:#W "

# Active window
set -g window-status-current-format "#[fg=#a6e3a1,bold] #I:#W "

# Window activity indicators
set -g window-status-activity-style "fg=#f9e2af,bold"

# Pane borders
set -g pane-border-style "fg=#45475a"
set -g pane-active-border-style "fg=#89b4fa"

# Message styling
set -g message-style "bg=#313244,fg=#cdd6f4"

# Copy mode styling
set -g mode-style "bg=#89b4fa,fg=#1e1e2e"


# ------------------------------------------------------------
# 11. ACTIVITY MONITORING
# ------------------------------------------------------------

# Monitor activity in background windows
setw -g monitor-activity on

# Highlight windows with activity
set -g visual-activity off

# Avoid bell notifications
set -g bell-action none


# ------------------------------------------------------------
# 12. PLUGINS (TPM)
# ------------------------------------------------------------

# Tmux Plugin Manager
set -g @plugin 'tmux-plugins/tpm'

# Save and restore sessions
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Automatically save sessions
set -g @plugin 'tmux-plugins/tmux-continuum'

# Save sessions every 15 minutes
set -g @continuum-save-interval '15'

# Automatically restore sessions on tmux startup
set -g @continuum-restore 'on'

# Initialize TPM (must be at the bottom)
run '~/.tmux/plugins/tpm/tpm'
TMUX_CONFIG

printf 'Installed tmux configuration at %s\n' "$target_config"

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
