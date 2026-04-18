# albertofp's dotfiles

## Overview

- **NixOS** (primary): fully declarative via a Nix flake + home-manager
- **macOS** (secondary): Homebrew + Ansible bootstrap playbook

## Architecture

### NixOS

Everything is managed through a single Nix flake (`flake.nix`). The configuration is split into two layers:

**System layer** (`nixos/system.nix` + `nixos/system/`): NixOS modules for boot, hardware, networking, audio, display server (Hyprland + SDDM), NVIDIA drivers, and system services. Evaluated by `nixos-rebuild`.

**User layer** (`nixos/home.nix` + `nixos/home/`): Home Manager modules for the shell (zsh, starship, tmux), desktop environment (Hyprland, Waybar, wlogout, hyprpaper), applications, and dotfile symlinks. Evaluated as part of the NixOS build via `home-manager.nixosModules`.

Key flake inputs beyond nixpkgs + home-manager:

| Input | Purpose |
|---|---|
| `agenix` | Age-encrypted secrets decrypted at boot to `/run/agenix/` |
| `zen-browser` | Zen browser (not yet in nixpkgs) |
| `hyprpaper` | Wallpaper daemon (tracks upstream closely) |
| `rust-overlay` | Stable Rust toolchain without rustup |

**Theming**: The entire stack uses Rose Pine. All palette hex values live in `nixos/lib/theme.nix` — no inline hex literals anywhere else.

**Secrets**: Runtime secrets (API keys, tokens) are stored as age-encrypted files in `secrets/` and decrypted by agenix at boot. They are sourced by zsh from `/run/agenix/shell-secrets` and never touch the Nix store.

**Live-editable configs**: Neovim and Ghostty configs under `.config/` are symlinked into `~` via `mkOutOfStoreSymlink`, so edits take effect immediately without a rebuild. Everything else (Hyprland, Waybar, zsh, tmux, starship) is Nix-managed.

To rebuild after changes:
```sh
rebuild
# expands to: sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure
```

### macOS

Managed by an Ansible playbook (`mac/ansible/`) bootstrapped via Homebrew. The `bin/dotfiles` script handles the full setup from a fresh machine. All macOS-specific configs live under `mac/`:

- `mac/.zshrc` / `mac/.tmux.conf` — shell and tmux (TPM-based)
- `mac/.config/starship.toml` — prompt config
- `mac/.config/aerospace/` — AeroSpace tiling WM
- `mac/.config/karabiner/` — Karabiner-Elements key remapping

### Bootstrap

The `bin/dotfiles` script bootstraps a new machine from GPG-encrypted files on a thumb drive (SSH keys, AWS credentials). It works on both NixOS and macOS.

```sh
bash dotfiles [OPTIONS] [THUMB_DIR]
```

| Option | Description |
|--------|-------------|
| `THUMB_DIR` | Path to the thumb drive. Auto-detected if omitted. |
| `--ssid <SSID>` | Connect to wifi before cloning (password read from `wifi.gpg`). |
| `--branch <BRANCH>` | Git branch to clone. Default: `main`. |
| `-h, --help` | Show full usage information. |

What it does:
1. Decrypts GPG-encrypted secrets from the thumb drive and installs them (`~/.ssh/`, `~/.aws/`)
2. Connects to wifi if needed
3. Clones this repo
4. **NixOS**: generates hardware config, runs `nixos-rebuild switch --flake`
5. **macOS**: installs Homebrew + Ansible, runs the Ansible bootstrap playbook
