{
  pkgs,
  zen-browser-pkg ? null,
  ...
}:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    LOCK="  Lock"
    SLEEP="  Sleep"
    REBOOT="  Restart"
    SHUTDOWN="  Shutdown"

    CHOICE=$(printf '%s\n' "$LOCK" "$SLEEP" "$REBOOT" "$SHUTDOWN" \
      | ${pkgs.wofi}/bin/wofi --dmenu \
             --prompt "Power" \
             --width 200 \
             --height 174 \
             --lines 4 \
             --hide-scroll \
             --no-actions \
             --insensitive)

    case "$CHOICE" in
      "$LOCK")
        ${pkgs.hyprlock}/bin/hyprlock
        ;;
      "$SLEEP")
        ${pkgs.hyprlock}/bin/hyprlock & sleep 0.5 && systemctl suspend -i
        ;;
      "$REBOOT")
        systemctl reboot
        ;;
      "$SHUTDOWN")
        systemctl poweroff
        ;;
    esac
  '';
in
{
  home.packages =
    with pkgs;
    [
      # Shell / terminal
      tmux

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
      hyprlock
      power-menu
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
