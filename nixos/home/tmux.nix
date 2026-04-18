{ pkgs, ... }:

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

      # Rose Pine theme
      rosepine_moon_base="#232136"
      rosepine_moon_surface="#2a273f"
      rosepine_moon_overlay="#393552"
      rosepine_moon_muted="#6e6a86"
      rosepine_moon_subtle="#908caa"
      rosepine_moon_text="#e0def4"
      rosepine_moon_love="#eb6f92"
      rosepine_moon_gold="#f6c177"
      rosepine_moon_rose="#ea9a97"
      rosepine_moon_pine="#3e8fb0"
      rosepine_moon_foam="#9ccfd8"
      rosepine_moon_iris="#c4a7e7"
      rosepine_moon_hl_low="#2a283e"
      rosepine_moon_hl_med="#44415a"
      rosepine_moon_hl_high="#56526e"

      set -g display-panes-active-colour "''${rosepine_moon_text}"
      set -g display-panes-colour "''${rosepine_moon_gold}"
      set -g status-style "fg=''${rosepine_moon_pine},bg=''${rosepine_moon_base}"
      set -g message-style "fg=''${rosepine_moon_muted},bg=''${rosepine_moon_base}"
      set -g message-command-style "fg=''${rosepine_moon_base},bg=''${rosepine_moon_gold}"
      set -g pane-border-style "fg=''${rosepine_moon_hl_high}"
      set -g pane-active-border-style "fg=''${rosepine_moon_gold}"
      set -gw window-status-style "fg=''${rosepine_moon_iris},bg=''${rosepine_moon_base}"
      set -gw window-status-activity-style "fg=''${rosepine_moon_base},bg=''${rosepine_moon_rose}"
      set -gw window-status-current-style "fg=''${rosepine_moon_gold},bg=''${rosepine_moon_base}"

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
