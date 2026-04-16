{ config, pkgs, zen-browser-pkg ? null, dotfilesRoot ? null, ... }:

{
  home.username = "alberto";
  home.homeDirectory = "/home/alberto";
  home.stateVersion = "24.11";

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Shell / terminal
    zsh
    tmux
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
    ghostty
    jellyfin-media-player
    slack
    localsend
    wl-clipboard
    silicon       # code screenshot tool
    wlsunset      # screen colour temperature (Wayland replacement for redshift)

    # Hyprland user-space tools (compositor itself enabled in system.nix)
    waybar
    wofi
    networkmanagerapplet  # nm-applet
    brightnessctl
    playerctl

    # AWS / cloud
    awscli2

    # GitHub CLI
    gh

    # Fonts
    nerd-fonts.jetbrains-mono
  ] ++ (if zen-browser-pkg != null then [ zen-browser-pkg ] else []);

  # ── Dotfiles ──────────────────────────────────────────────────────────────
  home.file = let root = if dotfilesRoot != null then dotfilesRoot else ../..; in {
    ".zshrc".source                = "${root}/.zshrc";
    ".tmux.conf".source            = "${root}/.tmux.conf";
    ".gitconfig".source            = "${root}/.gitconfig";
    ".gitconfig-jet".source        = "${root}/.gitconfig-jet";
    ".config/nvim".source          = "${root}/.config/nvim";
    ".config/ghostty".source       = "${root}/.config/ghostty";
    ".config/hypr".source          = "${root}/.config/hypr";
    ".config/waybar".source        = "${root}/.config/waybar";
    ".config/starship.toml".source = "${root}/.config/starship.toml";
  };

  # ── Programs ──────────────────────────────────────────────────────────────
  programs.home-manager.enable = true;

  programs.starship = {
    enable              = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable              = true;
    enableZshIntegration = true;
  };
}
