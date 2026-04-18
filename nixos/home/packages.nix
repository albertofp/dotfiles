{
  pkgs,
  zen-browser-pkg ? null,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # Shell / terminal
      tmux

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
