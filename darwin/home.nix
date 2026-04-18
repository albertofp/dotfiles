_: {
  imports = [
    # ── Shared (Linux + macOS) ─────────────────────────────────────────────────
    ../home/packages.nix
    ../home/zsh.nix
    ../home/tmux.nix
    ../home/starship.nix
    ../home/session.nix
    # ── macOS-only ────────────────────────────────────────────────────────────
    ./home/dotfiles.nix
    ./home/desktop.nix
  ];

  home = {
    username = "albertopluecker";
    homeDirectory = "/Users/albertopluecker";
    stateVersion = "24.11";
    sessionVariables = {
      GOCACHE = "$HOME/Library/Caches/go-build";
      PERSONAL_EMAIL = "albertopluecker@gmail.com";
      PERSONAL_SSH_KEY = "$HOME/.ssh/id_home_github";
    };
  };
}
