{
  pkgs,
  zen-browser-pkg ? null,
  ...
}:

let
  # helmfile pinned to 0.165.0 — helm-core requires this version
  pinnedPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/05bbf675397d5366259409139039af8077d695ce.tar.gz";
    sha256 = "1r26vjqmzgphfnby5lkfihz6i3y70hq84bpkwd43qjjvgxkcyki0";
  }) { inherit (pkgs) system; };
in
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
      k9s
      kustomize
      gum
      hyperfine
      pyenv

      # Media / screen tools
      ffmpeg
      mpv
      silicon

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
        jellyfin-desktop

        # Hyprland user-space tools
        wofi
        sddm-astronaut
        networkmanagerapplet
        brightnessctl
        playerctl
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ])
    )
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (
      [
        # Container runtime (colima = VM daemon, docker = CLI client)
        docker
        podman

        # Atlassian CLI
        acli

        # Dev
        claude-code
        kubernetes-helm
        pinnedPkgs.helmfile
        confluent-cli

        # Encryption
        sops
      ]
      ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else [ ])
    );
}
