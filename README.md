# albertofp's dotfiles

## Overview

- **Linux (NixOS)**: managed via [home-manager](https://github.com/nix-community/home-manager) + `nixos-rebuild`
- **macOS**: managed via Homebrew + Ansible

Secrets (SSH keys, shell env, AWS credentials, wifi password) are stored as GPG-encrypted files on a thumb drive and decrypted at bootstrap time.

## Usage

The `bin/dotfiles` script is designed to live on a thumb drive alongside the encrypted secrets. Run it on a fresh machine to bootstrap everything automatically.

```bash
bash dotfiles [OPTIONS] [THUMB_DIR]
```

### Options

| Option | Description |
|--------|-------------|
| `THUMB_DIR` | Path to the thumb drive. Auto-detected if omitted. |
| `--ssid <SSID>` | Connect to wifi before cloning (password read from `wifi.gpg`). |
| `--branch <BRANCH>` | Git branch to clone. Default: `main`. |
| `-h, --help` | Show full usage information. |

### Examples

```bash
# Auto-detect thumb drive, connect to stored wifi, use main branch:
bash dotfiles

# Explicit thumb drive path:
bash dotfiles /run/media/nixos/KEYS

# Connect to a specific wifi network:
bash dotfiles --ssid MyNetwork

# Use a specific branch:
bash dotfiles --branch my-feature-branch
```

### What it does

1. Reads GPG-encrypted secrets from the thumb drive and installs them (`~/.ssh/`, `~/.zshenv`, `~/.aws/`)
2. Connects to wifi if needed
3. Clones this repo
4. **NixOS**: installs Nix if needed, generates hardware config, runs `nixos-rebuild switch --flake`
5. **macOS**: installs Homebrew + Ansible if needed, runs the Ansible bootstrap playbook

### Thumb drive contents

The following GPG-encrypted files are expected (AES256, passphrase):

| File | Destination |
|------|-------------|
| `id_home_github.gpg` | `~/.ssh/id_home_github` |
| `hetzner.gpg` | `~/.ssh/hetzner` |
| `work_github.gpg` | `~/.ssh/work_github` |
| `work_github.pub.gpg` | `~/.ssh/work_github.pub` |
| `.zshenv.gpg` | `~/.zshenv` |
| `aws_config.gpg` | `~/.aws/config` |
| `aws_credentials.gpg` | `~/.aws/credentials` |
| `wifi.gpg` | used for wifi auth, not installed |
| `dotfiles` | this script |

Any additional `*.gpg` files found are decrypted into `~/.ssh/`.
