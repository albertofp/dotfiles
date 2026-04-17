{
  pkgs,
  config,
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
        runelite
        piper
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
    # Using mkOutOfStoreSymlink so that editing files directly in the repo
    # takes effect immediately — no rebuild needed for config changes.
    file =
      let
        dotfiles = "/home/alberto/dotfiles";
        link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
      in
      {
        ".zshrc".source = link ".zshrc";
        ".tmux.conf".source = link ".tmux.conf";
        ".gitconfig".source = link ".gitconfig";
        ".gitconfig-jet".source = link ".gitconfig-jet";
        ".config/nvim".source = link ".config/nvim";
        ".config/ghostty".source = link ".config/ghostty";
        ".config/hypr".source = link ".config/hypr";
        ".config/waybar".source = link ".config/waybar";

      };
  };

  # ── Programs ──────────────────────────────────────────────────────────────
  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$character";
        right_format = "$all";
        palette = "rose-pine";
        command_timeout = 1000;

        character = {
          success_symbol = "[➜](bold green) ";
          error_symbol = "[✗](bold red) ";
          vimcmd_symbol = "[](bold green) ";
        };

        directory = {
          style = "foam";
          read_only = " 󰌾";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          format = "[$symbol$branch ]($style)";
          disabled = false;
          ignore_branches = [
            "master"
            "main"
          ];
        };

        git_status = {
          ignore_submodules = true;
          style = "rose";
          stashed = "*\${count}";
          modified = "!\${count}";
          staged = "+\${count}";
          untracked = "?\${count}";
          deleted = "✘\${count}";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇡\${ahead_count}⇣\${behind_count}";
        };

        golang = {
          disabled = false;
          format = "[$symbol($version )]($style)";
          style = "bold blue";
          symbol = " ";
        };

        python = {
          symbol = " ";
          style = "gold bold";
          format = "[\${symbol}\${pyenv_prefix}(\${version} )(\(\${virtualenv}\) )]($style)";
        };

        c = {
          symbol = " ";
          format = "[$symbol($version(-$name) )]($style)";
        };

        kubernetes = {
          symbol = "󱃾 ";
          disabled = false;
          format = "[$symbol$context( \\($namespace\\))](bold $style) ";
          contexts = [
            {
              context_pattern = "gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-2";
              style = "foam";
              context_alias = "prod";
            }
            {
              context_pattern = "gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-2";
              style = "iris";
              context_alias = "stage";
            }
          ];
        };

        terraform.disabled = true;
        buf.disabled = true;
        docker_context = {
          disabled = true;
          symbol = " ";
        };
        gcloud = {
          symbol = "󱇶 ";
          disabled = true;
        };
        aws = {
          symbol = "  ";
          disabled = true;
        };
        time = {
          disabled = true;
          format = "[$time]($style) ";
          style = "subtle";
        };
        line_break.disabled = true;

        nodejs = {
          style = "green";
          format = "[$symbol$version](green) ";
        };
        package = {
          symbol = "󰏗 ";
          format = "[$symbol$version](208 bold) ";
        };

        "palettes.rose-pine" = {
          base = "#191724";
          surface = "#1f1d2e";
          overlay = "#26233a";
          muted = "#6e6a86";
          subtle = "#908caa";
          text = "#e0def4";
          love = "#eb6f92";
          gold = "#f6c177";
          rose = "#ebbcba";
          pine = "#31748f";
          foam = "#9ccfd8";
          iris = "#c4a7e7";
          highlight_low = "#21202e";
          highlight_med = "#403d52";
          highlight_high = "#524f67";
        };
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # Disable home-manager's systemd integration for Hyprland — conflicts with UWSM
  wayland.windowManager.hyprland.systemd.enable = false;

  # ── Dark theme ────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
