# OpenCode Session Handoff

## Goal
NixOS migration — dotfiles working, Hyprland launching. Continue from here.

## Current State
- Hyprland launches and works via SDDM
- NVIDIA legacy_580 (580.142) driver — correct for GTX 1080
- home-manager files linking correctly
- zsh plugins fix committed, opencode added to packages — **rebuild pending**
- DNS fix committed — **rebuild pending**

## Pending Rebuild
```bash
cd /home/alberto/dotfiles && git pull
sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure
```

## After Rebuild
- Run `opencode` to authenticate (first launch prompts for API key)
- Test zsh syntax highlighting and autosuggestions work
- Fix Hyprland config errors (check `~/.local/share/hyprland/hyprland.log`)

## Key Facts
- Repo: `git@github.com:albertofp/dotfiles.git`, branch `nixos-migration`
- Rebuild cmd: `sudo nixos-rebuild switch --flake path:/home/alberto/dotfiles#alberto --impure`
- Flake at repo root (`/home/alberto/dotfiles/flake.nix`)
- NixOS configs in `nixos/` subdir
- GPU: GTX 1080 (GP104), driver: `nvidiaPackages.legacy_580`
- Display: Dell U3419W 3440x1440 on DP-3
- SDDM X11 mode (`wayland.enable = false`) — Wayland mode crashes with NVIDIA
- Hyprland with UWSM (`withUWSM = true`, `systemd.enable = false` in home.nix)
- `GBM_BACKEND=drm` set in system env to avoid Mesa 25.x crash

## Known Issues
- SDDM greeter occasionally fails on first boot (exit code 6) — restart display-manager fixes it
  ```bash
  systemctl restart display-manager
  ```
- Hyprland config has errors — check log after login

## File Structure
```
dotfiles/
├── flake.nix           ← flake entry point
├── flake.lock
├── nixos/
│   ├── system.nix      ← NixOS system config
│   ├── home.nix        ← home-manager config
│   └── hardware.nix    ← hardware config
├── .config/
│   ├── hypr/hyprland.conf
│   ├── waybar/
│   ├── ghostty/
│   └── nvim/
└── .zshrc
```

## Still To Do
- Fix Hyprland config errors
- Set root password: `passwd root`
- Re-enable bluetooth once stable
- Test full bootstrap flow
- Merge `nixos-migration` to `main` once verified
- Clean up debug log files from repo root
