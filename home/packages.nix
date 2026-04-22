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

      # Secrets
      age

      # CI / workflow linting
      actionlint

      # Rust toolchain — pinned stable via rust-overlay
      rust-bin.stable.latest.default

      # AWS / cloud
      awscli2

      # GitHub CLI
      gh

      # Secrets
      age

      # direnv — per-directory environment variables
      direnv

      # OpenCode AI coding agent
      opencode

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
        jellyfin

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
        podman

        # Atlassian CLI
        acli
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ])
    );
}
