{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  networking.hosts = {
    # Add custom /etc/hosts entries here, e.g.:
    # "192.168.1.100" = [ "mydevice.local" ];
  };

  # ── Locale / time ─────────────────────────────────────────────────────────
  time.timeZone                   = "Europe/Amsterdam";
  i18n.defaultLocale              = "en_US.UTF-8";

  # ── NVIDIA ────────────────────────────────────────────────────────────────
  # Requires hardware.nix to set: boot.kernelModules = [ "nvidia" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable   = true;
    open                 = false;   # use proprietary kernel module
    nvidiaSettings       = true;
    package              = config.boot.kernelPackages.nvidiaPackages.stable;

    # Power management — safe default; tune if you have issues on suspend
    powerManagement.enable             = false;
    powerManagement.finegrained        = false;
  };

  hardware.graphics.enable = true;

  # ── Hyprland (compositor) ─────────────────────────────────────────────────
  programs.hyprland = {
    enable         = true;
    xwayland.enable = true;
  };

  # XDG portal needed for screenshare, file pickers, etc.
  xdg.portal = {
    enable      = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Display manager — greet with SDDM on Wayland
  services.displayManager.sddm = {
    enable      = true;
    wayland.enable = true;
  };

  # ── Audio (Pipewire) ──────────────────────────────────────────────────────
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    wireplumber.enable = true;
  };
  # Disable PulseAudio — conflicts with Pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  # ── Bluetooth ─────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # ── Docker ────────────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable         = true;
    enableOnBoot   = true;
  };

  # ── SSH ───────────────────────────────────────────────────────────────────
  services.openssh = {
    enable          = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  # ── Shell ─────────────────────────────────────────────────────────────────
  programs.zsh.enable = true;

  # ── Users ─────────────────────────────────────────────────────────────────
  # Password is set imperatively on first boot: `passwd alberto`
  users.users.alberto = {
    isNormalUser   = true;
    shell          = pkgs.zsh;
    extraGroups    = [ "wheel" "docker" "networkmanager" "video" "audio" ];

    # Public key for SSH login — private key lives on thumb drive
    openssh.authorizedKeys.keyFiles = [ ../ssh/id_home_github.pub ];
  };

  # Allow `sudo` for wheel group without password prompt during bootstrap
  # (tighten after first boot if preferred)
  security.sudo.wheelNeedsPassword = false;

  # ── Root password ─────────────────────────────────────────────────────────
  # Set imperatively: `sudo passwd root`
  # Declarative option (hashed): users.users.root.hashedPassword = "...";

  # ── Flatpak (for apps not in nixpkgs, e.g. Notion) ──────────────────────
  services.flatpak.enable = true;
  # After first boot: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  # Then: flatpak install flathub notion.so.Notion

  # ── System packages (minimal — user packages live in home.nix) ────────────
  environment.systemPackages = with pkgs; [
    git
    curl
    vim
    xdg-desktop-portal-hyprland
  ];

  system.stateVersion = "24.11";
}
