# albertofp's dotfiles

## Overview

- **NixOS** (primary): fully declarative via a Nix flake + home-manager
- **macOS** (secondary): nix-darwin + home-manager, sharing most config with NixOS

## Architecture

### NixOS

Everything is managed through a single Nix flake (`flake.nix`). The configuration is split into two layers:

**System layer** (`nixos/system.nix` + `nixos/system/`): NixOS modules for boot, hardware, networking, audio, display server (Hyprland + SDDM), NVIDIA drivers, and system services. Evaluated by `nixos-rebuild`.

**User layer** (`nixos/home.nix` + shared `home/` + `nixos/home/`): Home Manager modules for the shell (zsh, starship, tmux), desktop environment (Hyprland, Waybar, wlogout, hyprpaper), applications, and dotfile symlinks. The shell, tmux, starship, package, and session modules live in the shared `home/` directory and are consumed by both NixOS and macOS. Evaluated as part of the NixOS build via `home-manager.nixosModules`.

Key flake inputs beyond nixpkgs + home-manager:

| Input | Purpose |
|---|---|
| `agenix` | Age-encrypted secrets decrypted at boot to `/run/agenix/` |
| `nix-darwin` | macOS system configuration (system defaults, Homebrew, launchd) |
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

Managed by nix-darwin + home-manager. The `darwin/` directory contains all macOS-specific config:

- `darwin/system.nix` — nix-darwin system config: `system.primaryUser`, macOS defaults, Homebrew casks for apps unavailable in nixpkgs, `nix.enable = false` (Determinate Nix manages its own daemon)
- `darwin/home.nix` — HM entry point; imports shared modules from `home/` + macOS-only modules
- `darwin/home/dotfiles.nix` — live symlinks (macOS paths under `/Users/albertopluecker/`)
- `darwin/home/desktop.nix` — fzf, SSH config
- `home/zsh.nix` — shared shell config; macOS-specific extras behind `isDarwin` guards

**Package management priority:** nixpkgs first → flakes for community-packaged tools → Homebrew only for proprietary/macOS-only apps with no nix packaging path (aerospace, raycast, etc.).

To rebuild after changes on macOS:
```sh
rebuild
# expands to: darwin-rebuild switch --flake path:/Users/albertopluecker/dotfiles#alberto-mac --impure
```

The legacy `mac/` directory is kept for reference only and is no longer the active macOS config.

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
3. Installs Homebrew (macOS only — needed for non-nix casks)
4. Installs Nix via Determinate Systems (macOS) or assumes pre-installed (NixOS live ISO)
5. Clones this repo
6. **NixOS**: generates hardware config, runs `nixos-rebuild switch --flake`
7. **macOS**: runs `nix run nix-darwin -- switch --flake ...#alberto-mac`
