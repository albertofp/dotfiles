_:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Disable home-manager's systemd integration for Hyprland — conflicts with UWSM
  wayland.windowManager.hyprland.systemd.enable = false;

  # ── SSH agent ────────────────────────────────────────────────────────────────
  # One persistent agent per user session; key is added on first use via ssh config.
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  # ── Dark theme ──────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = null;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
