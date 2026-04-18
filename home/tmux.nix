{ pkgs, ... }:

let
  m = (import ../nixos/lib/theme.nix).moon;
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    baseIndex = 1;
    mouse = true;
    sensibleOnTop = true;
    resizeAmount = 5;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
    ];
    extraConfig = ''
      # Color support
      set -g terminal-overrides '*:smcup@:rmcup@'
      set -as terminal-features ",*:RGB"
      set -ga terminal-overrides ",*256col*:Tc"

      # General
      set -g status-position top
      set -s set-clipboard on
      set -g allow-passthrough on
      setw -g pane-base-index 1
      set -g detach-on-destroy off
      set -g renumber-windows on

      # Rose Pine Moon theme
      set -g display-panes-active-colour "${m.text}"
      set -g display-panes-colour "${m.gold}"
      set -g status-style "fg=${m.pine},bg=${m.base}"
      set -g message-style "fg=${m.muted},bg=${m.base}"
      set -g message-command-style "fg=${m.base},bg=${m.gold}"
      set -g pane-border-style "fg=${m.highlightHigh}"
      set -g pane-active-border-style "fg=${m.gold}"
      set -gw window-status-style "fg=${m.iris},bg=${m.base}"
      set -gw window-status-activity-style "fg=${m.base},bg=${m.rose}"
      set -gw window-status-current-style "fg=${m.gold},bg=${m.base}"

      # Fix scrolling in k9s
      bind -Troot WheelUpPane if-shell -F '#{alternate_on}' 'send-keys -M' 'copy-mode -e'
      bind -Troot WheelDownPane if-shell -F '#{alternate_on}' 'send-keys -M' 'send-keys -M'

      # Splits
      bind-key '"' split-window -v -c "#{pane_current_path}"
      bind-key '%' split-window -h -c "#{pane_current_path}"

      # Pane navigation (vim-style)
      unbind-key h
      unbind-key j
      unbind-key k
      unbind-key l
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Session management
      bind S command-prompt -p "New session name:" "new-session -s '%%'"
      bind K confirm-before -p "Kill current session?" "kill-session"
      bind R command-prompt -p "Rename session:" "rename-session '%%'"
      bind L choose-session
      bind D detach
      bind-key x kill-pane
    '';
  };
}
