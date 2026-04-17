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

    sessionVariables = {
      EDITOR = "nvim";
      GOPATH = "$HOME/go";
      GOMODCACHE = "$HOME/go/pkg/mod";
      GOCACHE = "$HOME/.cache/go-build";
      DOTFILES_DIR = "$HOME/dotfiles";
      OPENSSL_CONF = "/dev/null";
      KIND_EXPERIMENTAL_PROVIDER = "podman";
      PERSONAL_EMAIL = "albertopluecker@gmail.com";
      PERSONAL_SSH_KEY = "$HOME/.ssh/id_home_github";
      WORK_EMAIL = "alberto.pluecker@justeattakeaway.com";
      WORK_SSH_KEY = "$HOME/.ssh/work_github";
      FZF_DEFAULT_OPTS = ''
        --color=fg:#908caa,bg:#191724,hl:#ebbcba
        --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
        --color=border:#403d52,header:#31748f,gutter:#191724
        --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
        --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa'';
    };

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
      "\${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
    ];

    # ── Packages ──────────────────────────────────────────────────────────────
    packages =
      with pkgs;
      [
        # Shell / terminal
        tmux

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

    zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 50000;
        save = 50000;
        extended = true;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };

      shellAliases = {
        # NixOS
        rebuild = "sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure";

        # Editors
        n = "nvim";
        nvimconfig = "nvim ~/.config/nvim/";
        zshconfig = "nvim ~/dotfiles/.zshrc";
        tmuxconfig = "nvim ~/dotfiles/.tmux.conf";
        ghosttyconfig = "nvim ~/dotfiles/.config/ghostty/config";
        hyprconfig = "nvim ~/dotfiles/.config/hypr/hyprland.conf";
        reload = "source ~/.zshrc";

        # Navigation
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        proj = "cd $HOME/github/";

        # Git
        gp = "git push";
        gs = "git status";
        gd = "git diff";
        ga = "git add -p";
        gc = "git_commit_m";
        gca = "git commit --amend";
        gcan = "git commit --amend --no-edit";
        gco = "git checkout";
        gcb = "git checkout -b";
        dog = "git log --oneline --all --decorate --graph";
        gg = "git branch | fzf | xargs -n 1 git checkout";
        gbd = "git branch -D";
        gpf = "git push --force-with-lease";
        gcpf = "git add . && git commit --amend --no-edit && git push --force-with-lease";
        glc = "git log --oneline | head -n 1 | awk '{print $1}' | tr -d '\n' | cut -c -7";
        prw = "gh pr view --web";
        Prw = "gh pr view --web";
        PRw = "gh pr view --web";
        rw = "gh repo view --web";
        ghpc = "gh pr create";
        ghrw = "gh run list --status=completed --limit 1| awk '{print $6}'";

        # Files
        lt = "eza --tree --level=2 --long --icons";
        ls = "eza -l --icons";
        la = "eza -l --icons -a";

        # Tools
        k = "kubectl";
        tf = "terraform";
        tg = "terragrunt";
        kill9042 = "lsof -ti :9042 | xargs kill -9";
        dockerkill = "docker stop $(docker ps -a -q)";

        # Ansible
        sync = "ANSIBLE_PYTHON_INTERPRETER=auto_silent ansible-playbook ~/dotfiles/ansible/playbooks/bootstrap.yaml --connection=local --inventory=localhost, --forks=10";
      };

      initContent = ''
        # Auto-attach to tmux on interactive shells
        if [[ -t 1 && -z "$TMUX" ]]; then
          tmux attach || tmux new
        fi

        # Secrets (API keys, tokens — decrypted by agenix at boot)
        [[ -f /run/agenix/shell-secrets ]] && source /run/agenix/shell-secrets

        # kubectl completion
        [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

        # bashcompinit (needed for some CLI completions e.g. terraform)
        autoload -U +X bashcompinit && bashcompinit

        # SSH agent
        eval $(ssh-agent -s) > /dev/null 2>&1 && ssh-add -q $HOME/.ssh/id_home_github > /dev/null 2>&1

        # Git commit helper
        function git_commit_m { git commit -m "$*" }

        # mkdir + cd
        function takedir() { mkdir -p $@ && cd ''${@:$#} }

        function takeurl() {
          local data thedir
          data="$(mktemp)"
          curl -L "$1" > "$data"
          tar xf "$data"
          thedir="$(tar tf "$data" | head -n 1)"
          rm "$data"
          cd "$thedir"
        }

        function takegit() {
          git clone "$1"
          cd "$(basename ''${1%%.git})"
        }

        function take() {
          if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
            takeurl "$1"
          elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
            takegit "$1"
          else
            takedir "$@"
          fi
        }

        function aws-login() {
          local profile="''${1}"
          if [[ -z "$profile" ]]; then
            echo "Usage: aws-login <profile-name>"
            return 1
          fi
          aws sso login --profile "''${profile}" && \
          aws eks update-kubeconfig --profile "''${profile}" --name "''${profile}" --alias "''${profile}"
        }

        function aws-login-all() {
          local -A LEGACY_CLUSTERS=(
            [infra-eks-dev-1]="eks-cluster-dev"
            [sre-eks-dev-1]="eks-cluster-dev"
            [sre-eks-migration-1]="eks-cluster-dev"
            [sre-eks-staging-1]="eks-cluster-staging-2"
            [sre-eks-production-1]="eks-cluster-prod"
            [sre-eks-gitlab-1]="eks-cluster-prod"
            [sre-eks-intsvc-1]="eks-cluster-prod"
            [p-ew1-dreks]="p-ew1-dreks"
          )
          local SONIC_PROFILES=(
            euw1-pdv-sbx-2 euw1-pdv-qa-2 euw1-pdv-qa-3
            euw1-pdv-stg-5 euw1-pdv-stg-6 euw1-pdv-prd-5 euw1-pdv-prd-6
            usw2-pdv-qa-1 usw2-pdv-stg-1 usw2-pdv-prd-2
            apse2-pdv-qa-2 apse2-pdv-stg-2 apse2-pdv-prd-3
            euw1-plt-stg-2 euw1-plt-prd-2 usw2-plt-prd-2 apse2-plt-prd-1
            euw1-pmt-stg-1 euw1-pmt-prd-1 apse2-pmt-stg-1 apse2-pmt-prd-1
          )
          echo "==> Logging in to AWS SSO (orga portal)..."
          aws sso login --profile orga || { echo "ERROR: SSO login failed."; return 1 }
          local failed=()
          echo "\n==> Updating kubeconfig for legacy SRE-EKS clusters..."
          for profile cluster_name in ''${(kv)LEGACY_CLUSTERS}; do
            echo "    [legacy] profile=''${profile} cluster=''${cluster_name}"
            aws eks update-kubeconfig --profile "''${profile}" --name "''${cluster_name}" --alias "''${cluster_name}" 2>&1 \
              || failed+=("''${profile} (cluster: ''${cluster_name})")
          done
          echo "\n==> Updating kubeconfig for Sonic Runtime (OneEKS) clusters..."
          for profile in "''${SONIC_PROFILES[@]}"; do
            echo "    [sonic] profile=''${profile}"
            aws eks update-kubeconfig --profile "''${profile}" --name "''${profile}" --alias "''${profile}" 2>&1 \
              || failed+=("''${profile}")
          done
          echo ""
          if [[ ''${#failed[@]} -eq 0 ]]; then
            echo "==> Done. All kubeconfigs updated successfully."
          else
            echo "==> Done with errors. Failed profiles:"
            for f in "''${failed[@]}"; do echo "    - ''${f}"; done
          fi
        }
      '';
    };
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

        palettes = {
          rose-pine = {
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
    };
    tmux = {
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

        set display-panes-active-color "''${rosepine_moon_text}"
        set display-panes-color "''${rosepine_moon_gold}"
        set -g status-style "fg=''${rosepine_moon_pine},bg=''${rosepine_moon_base}"
        set -g message-style "fg=''${rosepine_moon_muted},bg=''${rosepine_moon_base}"
        set -g message-command-style "fg=''${rosepine_moon_base},bg=''${rosepine_moon_gold}"
        set -g pane-border-style "fg=''${rosepine_moon_hl_high}"
        set -g pane-active-border-style "fg=''${rosepine_moon_gold}"
        set -w window-status-style "fg=''${rosepine_moon_iris},bg=''${rosepine_moon_base}"
        set -w window-status-activity-style "fg=''${rosepine_moon_base},bg=''${rosepine_moon_rose}"
        set -w window-status-current-style "fg=''${rosepine_moon_gold},bg=''${rosepine_moon_base}"

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
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = null;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
