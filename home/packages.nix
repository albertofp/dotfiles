{
  pkgs,
  zen-browser-pkg ? null,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # Editors / viewers
      neovim
      glow
      fastfetch
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
      cloc

      # Dev
      go
      nodejs
      deno
      shellcheck
      tree-sitter
      golangci-lint
      kubectl
      kubectx
      gum
      hyperfine
      pyenv

      # Media / screen tools
      ffmpeg
      mpv
      silicon
      yt-dlp

      # Network
      nmap

      # Nix linting / formatting
      statix
      deadnix
      nixfmt

      # Rust toolchain — pinned stable via rust-overlay
      rust-bin.stable.latest.default

      # AWS / cloud
      awscli2
      tailscale

      # GitHub CLI
      gh

      # OpenCode AI coding agent
      opencode

      # Apps
      anki
      jellyfin-media-player
      localsend
      signal-desktop
      telegram-desktop

      # Fonts
      nerd-fonts.jetbrains-mono
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux (
      [
        # Linux GUI / system
        piper
        ghostty
        runelite
        slack
        vlc
        wl-clipboard
        wlsunset
        cmatrix
        presenterm

        # Hyprland user-space tools
        wofi
        networkmanagerapplet
        brightnessctl
        playerctl
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ])
    )
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (
      [
        # Container runtime (colima = VM daemon, docker = CLI client)
        colima
        docker

        # Presentations
        presenterm
        cmatrix
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ])
      # ── Not available in nixpkgs — install manually ──────────────────────
      # aerospace    (tiling WM — macOS-only, not packaged)
      # raycast      (launcher — proprietary, not packaged)
      # terramate    (Terraform orchestration — not in nixpkgs)
      # okta-verify  (Okta device trust — proprietary)
      # ausweisapp   (German eID — check nixpkgs.ausweisapp2 for Linux only)
      # foobar2000   (audio player — macOS build not packaged)
      # qobuz        (music streaming — not packaged)
      # soulseek     (file sharing — not packaged for macOS)
      # tailscale-app (macOS system extension GUI — use tailscale CLI above)
      # whatsapp     (not packaged for macOS)
      # claude-code  (install via: npm install -g @anthropic-ai/claude-code)
      # google-chrome (install manually or via: nix run nixpkgs#google-chrome)
    );
}
