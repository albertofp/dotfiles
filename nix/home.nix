{ config, pkgs, ... }:

{
  home.username = "alberto";
  home.homeDirectory = "/home/alberto";
  home.stateVersion = "24.11";

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Shell / terminal
    zsh
    starship
    tmux
    fzf
    zsh-syntax-highlighting
    zsh-autosuggestions

    # Editors / viewers
    neovim
    glow
    presenterm
    lazygit

    # File utils
    eza
    bat
    tree
    stow
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
    golangci-lint
    kubectl
    kubectx
    gum

    # Rust toolchain (provides cargo, rustc)
    rustup

    # Apps / GUI
    firefox
    ghostty
    spotify
    slack
    localsend
    zen-browser
    wl-clipboard

    # AWS / cloud
    awscli2

    # GitHub CLI
    gh

    # Bluetooth
    bluez
    bluez-utils

    # Fonts
    nerd-fonts.jetbrains-mono
  ];

  # ── Dotfiles ──────────────────────────────────────────────────────────────
  # Mirror what `stow .` does from ~/dotfiles — symlink each config into $HOME.
  home.file = {
    ".zshrc".source    = ../. + "/.zshrc";
    ".tmux.conf".source = ../. + "/.tmux.conf";
    ".gitconfig".source = ../. + "/.gitconfig";
    ".gitconfig-jet".source = ../. + "/.gitconfig-jet";
    ".config/nvim".source   = ../. + "/.config/nvim";
    ".config/ghostty".source = ../. + "/.config/ghostty";
    ".config/hypr".source    = ../. + "/.config/hypr";
    ".config/starship.toml".source = ../. + "/.config/starship.toml";
  };

  # ── Programs managed by home-manager ──────────────────────────────────────
  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
