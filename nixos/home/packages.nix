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

      # Dev
      go
      nodejs

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

      # Rust toolchain — pinned stable via rust-overlay
      rust-bin.stable.latest.default

      # Apps / GUI
      runelite
      piper
      ghostty
      jellyfin-media-player
      slack
      localsend
      wl-clipboard
      silicon
      wlsunset

      # Hyprland user-space tools (compositor itself enabled in system.nix)
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
}
