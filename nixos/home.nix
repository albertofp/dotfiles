_: {
  imports = [
    # ── Shared (Linux + macOS) ─────────────────────────────────────────────────
    ../home/packages.nix
    ../home/zsh.nix
    ../home/tmux.nix
    ../home/starship.nix
    ../home/session.nix
    # ── Linux-only ────────────────────────────────────────────────────────────
    ./home/dotfiles.nix
    ./home/desktop.nix
    ./home/hyprland.nix
    ./home/waybar.nix
    ./home/wlogout.nix
    ./home/wallpaper.nix
  ];

  home = {
    username = "alberto";
    homeDirectory = "/home/alberto";
    stateVersion = "24.11";
    sessionVariables.GOCACHE = "$HOME/.cache/go-build";
    sessionPath = [ "\${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ];
  };
}
