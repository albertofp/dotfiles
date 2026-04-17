{
  pkgs,
  zen-browser-pkg ? null,
  ...
}:

{
  home = {
    username = "alberto";
    homeDirectory = "/home/alberto";
    stateVersion = "24.11";

    # ── Packages ──────────────────────────────────────────────────────────────
    packages =
      with pkgs;
      [
        # Shell / terminal
        zsh
        tmux
        zsh-syntax-highlighting
        zsh-autosuggestions

        # Editors / viewers
        neovim
        glow
        presenterm
        lazygit

        # File utils
        eza
        bat
        tree
        wget
        ripgrep
        jq
        yq
        btop
        htop

        # Dev
        go
        nodejs
        pyenv
        shellcheck
        tree-sitter
        golangci-lint
        kubectl
        kubectx
        gum

        # Nix linting / formatting
        statix
        deadnix
        nixfmt

        # Rust toolchain (provides cargo, rustc)
        rustup
        gcc # C linker required for cargo build steps (e.g. blink.cmp)

        # Apps / GUI
        ghostty
        jellyfin-media-player
        slack
        localsend
        wl-clipboard
        silicon # code screenshot tool
        wlsunset # screen colour temperature (Wayland replacement for redshift)

        # Hyprland user-space tools (compositor itself enabled in system.nix)
        waybar
        wofi
        networkmanagerapplet # nm-applet
        brightnessctl
        playerctl

        # AWS / cloud
        awscli2

        # GitHub CLI
        gh

        # OpenCode AI coding agent
        opencode

        # Fonts
        nerd-fonts.jetbrains-mono
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ]);

    # ── Dotfiles ──────────────────────────────────────────────────────────────
    file = {
      ".zshrc".source = ../.zshrc;
      ".tmux.conf".source = ../.tmux.conf;
      ".gitconfig".source = ../.gitconfig;
      ".gitconfig-jet".source = ../.gitconfig-jet;
      ".config/nvim" = {
        source = ../.config/nvim;
        recursive = true;
      };
      ".config/ghostty" = {
        source = ../.config/ghostty;
        recursive = true;
      };
      ".config/hypr" = {
        source = ../.config/hypr;
        recursive = true;
      };
      ".config/waybar" = {
        source = ../.config/waybar;
        recursive = true;
      };
      ".config/starship.toml".source = ../.config/starship.toml;
    };
  };

  # ── Programs ──────────────────────────────────────────────────────────────
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # Disable home-manager's systemd integration for Hyprland — conflicts with UWSM
  wayland.windowManager.hyprland.systemd.enable = false;
}
