{
  pkgs,
  lib,
  darwinUser,
  darwinHome,
  ...
}:
{
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
    username = darwinUser;
    homeDirectory = darwinHome;
    stateVersion = "24.11";
    sessionVariables = {
      GOCACHE = "$HOME/Library/Caches/go-build";
      PERSONAL_EMAIL = "albertopluecker@gmail.com";
      PERSONAL_SSH_KEY = "$HOME/.ssh/id_home_github";
    };

    # Decrypt shell secrets on every rebuild (runs as user, not root)
    activation.decryptShellSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      secrets_dir="$HOME/.local/secrets"
      mkdir -p "$secrets_dir"
      chmod 700 "$secrets_dir"
      if ${pkgs.age}/bin/age -d \
          -i "$HOME/.ssh/id_home_github" \
          "$HOME/dotfiles/secrets/shell-secrets.age" \
          > "$secrets_dir/shell-secrets.tmp" 2>/dev/null; then
        mv "$secrets_dir/shell-secrets.tmp" "$secrets_dir/shell-secrets"
        chmod 600 "$secrets_dir/shell-secrets"
      else
        rm -f "$secrets_dir/shell-secrets.tmp"
        echo "Warning: failed to decrypt shell-secrets.age (SSH key not available?)" >&2
      fi
    '';
  };
}
